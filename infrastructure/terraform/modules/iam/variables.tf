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

variable "deploy_branch" {
  description = "Branch whose workflow runs may assume the deploy role"
  type        = string
  default     = "main"
}

variable "create_oidc_provider" {
  type    = bool
  default = true
}
