terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "mathtutor-terraform-state"
    # key is set per environment at init time:
    #   terraform init -backend-config="key=prod/terraform.tfstate"
    #   terraform init -backend-config="key=staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "mathtutor-terraform-locks"
    encrypt        = true
  }
}
