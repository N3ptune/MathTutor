output "parameter_arns" {
  description = "ARNs of all SSM parameters"
  value       = [for p in aws_ssm_parameter.secrets : p.arn]
}

output "parameter_prefix" {
  description = "SSM parameter path prefix"
  value       = local.prefix
}
