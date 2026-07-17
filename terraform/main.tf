# S3 bucket for static website content
resource "aws_s3_bucket" "site" {
  bucket = "${var.project_name}-${data.aws_caller_identity.current.account_id}"

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Block all public access to S3 bucket
resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "site" {
  bucket = aws_s3_bucket.site.id

  versioning_configuration {
    status = "Enabled"
  }
}

# CloudFront Origin Access Control (OAC) for secure S3 access
resource "aws_cloudfront_origin_access_control" "site" {
  name                              = "${var.project_name}-oac"
  description                       = "OAC for ${var.project_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# S3 bucket policy granting CloudFront OAC read access
resource "aws_s3_bucket_policy" "cloudfront_access" {
  bucket = aws_s3_bucket.site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontOAC"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.site.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.site.id}"
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.site]
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "site" {
  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = "S3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.site.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  # Custom error response to handle SPA routing
  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 300
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    # Use CloudFront managed caching policy for optimized content delivery
    cache_policy_id = data.aws_cloudfront_cache_policy.optimized.id

    viewer_protocol_policy = "redirect-to-https"
  }

  # SSL/TLS certificate configuration
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Geographic restrictions (none applied)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_200"

  tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

# Data source for CloudFront managed caching policy
data "aws_cloudfront_cache_policy" "optimized" {
  name = "Managed-CachingOptimized"
}

# Data source for current AWS account ID
data "aws_caller_identity" "current" {}
