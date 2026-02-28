locals {
  cpu             = "1024"  # 1 vCPU (smallest)
  memory          = "2048"  # 2 GB  (smallest practical for Python + sympy)
  max_concurrency = 100
  max_size        = 2
  min_size        = 1
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# --- IAM: ECR access role (lets App Runner pull images) ---

resource "aws_iam_role" "apprunner_ecr_access" {
  name = "${var.name_prefix}-apprunner-ecr-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "apprunner_ecr_access" {
  name = "${var.name_prefix}-ecr-pull"
  role = aws_iam_role.apprunner_ecr_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
        ]
        Resource = "*"
      }
    ]
  })
}

# --- IAM: Instance role (runtime permissions for the container) ---

resource "aws_iam_role" "apprunner_instance" {
  name = "${var.name_prefix}-apprunner-instance"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "apprunner_ssm_read" {
  name = "${var.name_prefix}-ssm-read"
  role = aws_iam_role.apprunner_instance.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath",
        ]
        Resource = var.ssm_parameter_arns
      },
      {
        Effect   = "Allow"
        Action   = ["kms:Decrypt"]
        Resource = "*"
      }
    ]
  })
}

# --- Auto Scaling ---

resource "aws_apprunner_auto_scaling_configuration_version" "backend" {
  auto_scaling_configuration_name = "${var.name_prefix}-backend"
  max_concurrency                 = local.max_concurrency
  max_size                        = local.max_size
  min_size                        = local.min_size
}

# --- App Runner Service ---

resource "aws_apprunner_service" "backend" {
  service_name = "${var.name_prefix}-backend"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr_access.arn
    }

    image_repository {
      image_identifier      = "${var.ecr_repository_url}:latest"
      image_repository_type = "ECR"

      image_configuration {
        port = "8000"

        runtime_environment_variables = {
          ALLOWED_ORIGINS = "https://${var.cloudfront_url}"
          SSM_PREFIX      = var.ssm_prefix
        }

        runtime_environment_secrets = var.ssm_parameter_arn_map
      }
    }

    auto_deployments_enabled = false
  }

  instance_configuration {
    cpu               = local.cpu
    memory            = local.memory
    instance_role_arn = aws_iam_role.apprunner_instance.arn
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.backend.arn

  health_check_configuration {
    protocol            = "HTTP"
    path                = "/health"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 1
    unhealthy_threshold = 3
  }

  tags = {
    Project = var.name_prefix
  }
}
