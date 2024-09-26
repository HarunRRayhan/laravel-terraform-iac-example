locals {
  updated_env_variables = merge(var.env_variables, {
    APP_NAME      = var.application_name
    APP_URL       = "https://${var.domain_name}"
    DB_HOST       = var.db_host
    DB_PORT       = var.db_port
    DB_DATABASE   = var.db_name
    DB_USERNAME   = var.db_username
    DB_PASSWORD   = var.db_password
  })
}

resource "aws_secretsmanager_secret" "laravel_env" {
  name = "${var.application_name}/${var.environment}/laravel-env"
}

resource "aws_secretsmanager_secret_version" "laravel_env" {
  secret_id     = aws_secretsmanager_secret.laravel_env.id
  secret_string = jsonencode(local.updated_env_variables)
}