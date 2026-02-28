variable "name_prefix" {
  type = string
}

variable "github_repo" {
  description = "GitHub repository in org/repo format"
  type        = string
}

variable "s3_bucket_arn" {
  type = string
}

variable "cloudfront_distribution_arn" {
  type = string
}

variable "ecr_repository_arn" {
  type = string
}

variable "apprunner_service_arn" {
  type = string
}

variable "environment" {
  description = "Deployment environment (e.g. prod)"
  type        = string
}
