variable "name_prefix" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "ssm_parameter_arns" {
  description = "List of SSM parameter ARNs the instance role can read"
  type        = list(string)
}

variable "ssm_prefix" {
  description = "SSM parameter path prefix"
  type        = string
}

variable "ssm_parameter_arn_map" {
  description = "Map of secret name to SSM parameter ARN for runtime injection"
  type        = map(string)
}

variable "cloudfront_url" {
  description = "CloudFront domain for CORS allowed origins"
  type        = string
}
