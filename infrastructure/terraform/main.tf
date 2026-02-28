provider "aws" {
  region = var.aws_region
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

module "ssm" {
  source      = "./modules/ssm"
  name_prefix = local.name_prefix
  environment = var.environment
}

module "ecr" {
  source       = "./modules/ecr"
  name_prefix  = local.name_prefix
  project_name = var.project_name
}

module "s3_frontend" {
  source      = "./modules/s3-frontend"
  name_prefix = local.name_prefix
}

module "cloudfront" {
  source             = "./modules/cloudfront"
  s3_bucket_id       = module.s3_frontend.bucket_id
  s3_bucket_arn      = module.s3_frontend.bucket_arn
  s3_bucket_regional = module.s3_frontend.bucket_regional_domain_name
  name_prefix        = local.name_prefix
}

module "apprunner" {
  source             = "./modules/apprunner"
  name_prefix        = local.name_prefix
  ecr_repository_url = module.ecr.repository_url
  ssm_parameter_arns = module.ssm.parameter_arns
  ssm_prefix         = module.ssm.parameter_prefix
  cloudfront_url     = module.cloudfront.distribution_domain_name
}

module "iam" {
  source                  = "./modules/iam"
  name_prefix             = local.name_prefix
  github_repo             = var.github_repo
  s3_bucket_arn           = module.s3_frontend.bucket_arn
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
  ecr_repository_arn      = module.ecr.repository_arn
  apprunner_service_arn   = module.apprunner.service_arn
}
