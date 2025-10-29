# ===================================
# S3 Outputs
# ===================================

output "website_bucket_name" {
  description = "Name of the S3 bucket hosting the website"
  value       = aws_s3_bucket.website.id
}

output "website_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.website.arn
}

output "website_bucket_endpoint" {
  description = "S3 website endpoint"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "website_bucket_domain" {
  description = "S3 bucket domain name"
  value       = aws_s3_bucket.website.bucket_domain_name
}

# ===================================
# CloudFront Outputs
# ===================================

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.website.id
}

output "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.website.arn
}

output "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.website.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "CloudFront Route 53 zone ID"
  value       = aws_cloudfront_distribution.website.hosted_zone_id
}

# ===================================
# Website URL Outputs
# ===================================

output "website_url" {
  description = "Full URL to access the website"
  value       = var.domain_name != "" ? "https://${var.domain_name}" : "https://${aws_cloudfront_distribution.website.domain_name}"
}

output "website_url_with_www" {
  description = "Website URL with www subdomain"
  value       = var.domain_name != "" ? "https://www.${var.domain_name}" : null
}

output "s3_website_url" {
  description = "Direct S3 website URL (without CloudFront)"
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}

# ===================================
# Route 53 Outputs (if using custom domain)
# ===================================

output "route53_zone_id" {
  description = "Route 53 hosted zone ID"
  value       = var.domain_name != "" ? (var.create_route53_zone ? aws_route53_zone.main[0].zone_id : data.aws_route53_zone.main[0].zone_id) : null
}

output "route53_name_servers" {
  description = "Route 53 name servers (if zone was created)"
  value       = var.domain_name != "" && var.create_route53_zone ? aws_route53_zone.main[0].name_servers : null
}

# ===================================
# Certificate Outputs (if using custom domain)
# ===================================

output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = var.domain_name != "" ? aws_acm_certificate.website[0].arn : null
}

output "certificate_status" {
  description = "Status of the ACM certificate"
  value       = var.domain_name != "" ? aws_acm_certificate.website[0].status : null
}

# ===================================
# Deployment Instructions
# ===================================

output "deployment_instructions" {
  description = "Instructions for deploying website files"
  value       = <<-EOT
    
    ========================================
    DEPLOYMENT INSTRUCTIONS
    ========================================
    
    1. Upload website files to S3:
       aws s3 sync ../website/ s3://${aws_s3_bucket.website.id}/ --delete
    
    2. Invalidate CloudFront cache:
       aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.website.id} --paths "/*"
    
    3. Access your website:
       ${var.domain_name != "" ? "https://${var.domain_name}" : "https://${aws_cloudfront_distribution.website.domain_name}"}
    
    ${var.domain_name != "" && var.create_route53_zone ? "4. Update domain registrar with these name servers:\n       ${join("\n       ", aws_route53_zone.main[0].name_servers)}" : ""}
    
    ========================================
  EOT
}

# ===================================
# Cost Estimation
# ===================================

output "estimated_monthly_cost" {
  description = "Estimated monthly cost breakdown"
  value       = <<-EOT
    
    ========================================
    ESTIMATED MONTHLY COSTS (USD)
    ========================================
    
    S3 Storage (5GB):              ~$0.12
    S3 Requests (10K/month):       ~$0.05
    CloudFront (1GB transfer):     ~$0.08
    CloudFront Requests (10K):     ~$0.01
    ${var.domain_name != "" ? "Route 53 Hosted Zone:          ~$0.50" : ""}
    ${var.domain_name != "" ? "Route 53 Queries (1M):         ~$0.40" : ""}
    
    TOTAL:                         ~$${var.domain_name != "" ? "1.16" : "0.26"}/month
    
    Note: Costs may vary based on usage
    ========================================
  EOT
}