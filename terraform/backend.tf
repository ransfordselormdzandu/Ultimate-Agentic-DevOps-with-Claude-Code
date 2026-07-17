# Terraform State Backend Configuration
#
# INSTRUCTIONS FOR SETTING UP REMOTE STATE:
#
# 1. First run: `terraform init` (without backend)
#    This initializes Terraform with local state storage
#
# 2. Deploy resources: `terraform apply`
#    This creates your S3 and CloudFront infrastructure
#
# 3. Create a state bucket (if not already done):
#    In AWS Console or with Terraform, create an S3 bucket for state storage
#    (e.g., terraform-state-{account-id})
#
# 4. Uncomment the backend block below and update bucket name
#
# 5. Run: `terraform init -migrate-state`
#    This migrates your local state to the remote S3 backend
#
# Once migrated, all terraform state will be stored securely in S3.

# Uncomment and update the bucket name to enable remote state storage:
#
# terraform {
#   backend "s3" {
#     bucket         = "terraform-state-YOUR-ACCOUNT-ID"
#     key            = "portfolio-site/terraform.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }
