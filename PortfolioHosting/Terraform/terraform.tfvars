# ===================================
# Project Configuration
# ===================================

project_name = "harsh-portfolio"
environment  = "prod"
aws_region   = "us-east-1"

# ===================================
# Domain Configuration
# ===================================

# Leave empty if you don't have a custom domain
# Example: "harshvashi.com"
domain_name = ""

# Set to true if you need to create a new Route53 hosted zone
create_route53_zone = false

# ===================================
# S3 Configuration
# ===================================

enable_versioning = true
enable_logging    = false # Set to true for production

# ===================================
# CloudFront Configuration
# ===================================

cloudfront_price_class = "PriceClass_100" # US, Canada, Europe only
cloudfront_default_ttl = 3600             # 1 hour
cloudfront_max_ttl     = 86400            # 24 hours
cloudfront_min_ttl     = 0
enable_compression     = true

# ===================================
# Security Configuration
# ===================================

enable_waf = false

allowed_origins = ["*"]

# ===================================
# Tags
# ===================================

common_tags = {
  Project     = "Portfolio Website"
  Owner       = "Harsh Vashi"
  Email       = "harshvashi1998@gmail.com"
  ManagedBy   = "Terraform"
  Environment = "Production"
  Repository  = "https://github.com/harshvashi/aws-portfolio"
}