output "bucket_id" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.frontend.id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.frontend.arn
}

output "bucket_regional_domain_name" {
  description = "S3 bucket regional domain name for CloudFront origin"
  value       = aws_s3_bucket.frontend.bucket_regional_domain_name
}
