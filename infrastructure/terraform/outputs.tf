output "cloudfront_distribution_url" {
  description = "CloudFront distribution URL for the frontend"
  value       = "https://${module.cloudfront.distribution_domain_name}"
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID (needed for cache invalidation in CI/CD)"
  value       = module.cloudfront.distribution_id
}

output "apprunner_service_url" {
  description = "App Runner service URL for the backend API"
  value       = "https://${module.apprunner.service_url}"
}

output "ecr_repository_url" {
  description = "ECR repository URL for backend Docker images"
  value       = module.ecr.repository_url
}

output "s3_bucket_name" {
  description = "S3 bucket name for frontend assets"
  value       = module.s3_frontend.bucket_id
}

output "github_actions_role_arn" {
  description = "IAM role ARN for GitHub Actions OIDC"
  value       = module.iam.github_actions_role_arn
}
