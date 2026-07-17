# CLAUDE.md
This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.
## Project Overview
**DMI Portfolio Website** — a static HTML/CSS portfolio site for the DevOps Micro Internship Week 1 program. Teaches Nginx hosting, Linux basics, and deployment practices by having students deploy this site on an Ubuntu VM and keep it live for 24 hours.
**Key characteristics:**
- Pure static site (no build process, no backend)
- Single stylesheet (`style.css`), responsive design
- Minimal external dependencies (Font Awesome from CDN)
- Designed to be deployed with Nginx on Ubuntu


## Architecture

- Pure HTML5 and CSS3
- No JavaScript
- NO build step
- No framework

## Commands

- terraform init
- terraform plan
- terraform apply

## Conventions
- All infrastructure changes go through Terraform - never modify AWS resources manually
- No JavaScript in this project
- CSS uses mobile-first approach with breakpoints at 900px, 768px, and 600px

## Safety
- Never put secrets in this file. No API keys, passwords, or AWS credentials


## Critical Customization: Ownership Proof

Before any deployment, students **must** edit the footer in `index.html` to add their details. The footer currently credits "Pravin Mishra" and must be updated with:

```html
<p><strong>Deployed by:</strong> [Cohort] | [Name] | [Group] | [Week] | [Date]</p>
```

This ownership proof must be visible in screenshot submissions. When working on `index.html`, always check that the footer has been personalized.

## Local Testing

To preview the site locally without deploying to a server:

```bash
# Python 3
python -m http.server 8000

# Or Node.js (if available)
npx http-server -p 8000
```

Then open `http://localhost:8000` in a browser.

## Deployment Context

The site is deployed via:

```bash
sudo cp -r . /var/www/html/
sudo systemctl start nginx
sudo systemctl enable nginx
```

Accessible at `http://<public-ip>` after Nginx is running on Ubuntu. No build step, no CI/CD pipeline — just copy files and serve.

## Key Design Decisions

- **Single stylesheet** — all styling in `style.css` for simplicity
- **No frameworks** — vanilla HTML/CSS/JS to keep deployment minimal for beginners
- **Responsive design** — mobile menu (hamburger toggle) and flexible layouts
- **CDN dependencies** — Font Awesome via CDN to reduce file count
- **Smooth scrolling** — CSS `scroll-behavior: smooth` for polished feel
