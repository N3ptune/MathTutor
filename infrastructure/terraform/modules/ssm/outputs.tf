output "parameter_arns" {
  description = "ARNs of all SSM parameters"
  value       = [for p in aws_ssm_parameter.secrets : p.arn]
}

output "parameter_arn_map" {
  description = "Map of secret name to SSM parameter ARN"
  value       = { for name, p in aws_ssm_parameter.secrets : name => p.arn }
}

output "parameter_prefix" {
  description = "SSM parameter path prefix"
  value       = local.prefix
}
