locals {
  prefix = "/mathtutor/${var.environment}"

  secrets = [
    "OPENAI_API_KEY",
    "SUPABASE_URL",
    "SUPABASE_ANON_KEY",
    "SUPABASE_SERVICE_ROLE_KEY",
    "STRIPE_SECRET_KEY",
    "STRIPE_WEBHOOK_SECRET",
    "STRIPE_PRICE_ID",
    "SENTRY_DSN",
  ]
}

resource "aws_ssm_parameter" "secrets" {
  for_each = toset(local.secrets)

  name  = "${local.prefix}/${each.value}"
  type  = "SecureString"
  value = "PLACEHOLDER"

  lifecycle {
    ignore_changes = [value]
  }

  tags = {
    Project     = "mathtutor"
    Environment = var.environment
  }
}
