output "secret_arn" {
  value = aws_secretsmanager_secret.laravel_env.arn
}