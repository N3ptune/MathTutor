variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "mathtutor"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}

variable "deploy_branch" {
  description = "Git branch whose GitHub Actions runs may deploy this environment"
  type        = string
  default     = "main"
}

variable "create_github_oidc_provider" {
  description = "The GitHub OIDC provider is account-wide: create it in one environment (prod) and reuse it elsewhere"
  type        = bool
  default     = true
}

variable "frontend_domain_names" {
  description = "Custom domains for the frontend, e.g. [\"mathtutor.com\", \"www.mathtutor.com\"]. Empty uses the CloudFront domain."
  type        = list(string)
  default     = []
}

variable "frontend_certificate_arn" {
  description = "ACM certificate (in us-east-1) covering frontend_domain_names. Required when they are set."
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repository in org/repo format for OIDC trust"
  type        = string
}
