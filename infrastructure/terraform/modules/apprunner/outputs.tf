output "service_url" {
  description = "App Runner service URL"
  value       = aws_apprunner_service.backend.service_url
}

output "service_arn" {
  description = "App Runner service ARN"
  value       = aws_apprunner_service.backend.arn
}
