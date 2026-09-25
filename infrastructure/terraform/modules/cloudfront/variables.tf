variable "s3_bucket_id" {
  type = string
}

variable "s3_bucket_arn" {
  type = string
}

variable "s3_bucket_regional" {
  description = "S3 bucket regional domain name"
  type        = string
}

variable "name_prefix" {
  type = string
}

variable "domain_names" {
  description = "Custom domains served by the distribution"
  type        = list(string)
  default     = []
}

variable "certificate_arn" {
  description = "ACM certificate in us-east-1 for domain_names"
  type        = string
  default     = ""

  validation {
    condition     = length(var.domain_names) == 0 || var.certificate_arn != ""
    error_message = "certificate_arn is required when domain_names is set."
  }
}
