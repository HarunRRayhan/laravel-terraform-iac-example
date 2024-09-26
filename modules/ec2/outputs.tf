output "web_role_name" {
  description = "Name of the IAM role for EC2 instances"
  value       = aws_iam_role.web_role.name
}