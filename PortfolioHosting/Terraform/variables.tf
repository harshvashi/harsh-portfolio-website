# ===================================
# Project Configuration Variables
# ===================================

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "harsh-portfolio"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

# ===================================
# Domain Configuration (Optional)
# ===================================

variable "domain_name" {
  description = "Custom domain name for the website (leave empty if not using custom domain)"
  type        = string
  default     = ""

  validation {
    condition     = var.domain_name == "" || can(regex("^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]\\.[a-z]{2,}$", var.domain_name))
    error_message = "Domain name must be a valid domain format (e.g., example.com)"
  }
}

variable "create_route53_zone" {
  description = "Whether to create a new Route53 hosted zone (set to false if zone already exists)"
  type        = bool
  default     = false
}

# ===================================
# S3 Configuration
# ===================================

variable "enable_versioning" {
  description = "Enable versioning for S3 bucket"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Enable access logging for S3 bucket"
  type        = bool
  default     = false
}

# ===================================
# CloudFront Configuration
# ===================================

variable "cloudfront_price_class" {
  description = "CloudFront distribution price class"
  type        = string
  default     = "PriceClass_100" # US, Canada, Europe

  validation {
    condition     = contains(["PriceClass_100", "PriceClass_200", "PriceClass_All"], var.cloudfront_price_class)
    error_message = "Price class must be PriceClass_100, PriceClass_200, or PriceClass_All"
  }
}

variable "cloudfront_default_ttl" {
  description = "Default TTL for CloudFront cache (seconds)"
  type        = number
  default     = 3600 # 1 hour
}

variable "cloudfront_max_ttl" {
  description = "Maximum TTL for CloudFront cache (seconds)"
  type        = number
  default     = 86400 # 24 hours
}

variable "cloudfront_min_ttl" {
  description = "Minimum TTL for CloudFront cache (seconds)"
  type        = number
  default     = 0
}

variable "enable_compression" {
  description = "Enable compression for CloudFront"
  type        = bool
  default     = true
}

# ===================================
# Security Configuration
# ===================================

variable "enable_waf" {
  description = "Enable AWS WAF for CloudFront distribution"
  type        = bool
  default     = false
}

variable "allowed_origins" {
  description = "List of allowed origins for CORS"
  type        = list(string)
  default     = ["*"]
}

# ===================================
# Tags
# ===================================

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "Portfolio Website"
    ManagedBy   = "Terraform"
    Owner       = "Harsh Vashi"
    Environment = "Production"
  }
}