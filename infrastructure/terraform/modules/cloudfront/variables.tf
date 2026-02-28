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
