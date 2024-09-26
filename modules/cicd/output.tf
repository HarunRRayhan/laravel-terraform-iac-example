output "codebuild_role_name" {
  description = "Name of the IAM role for CodeBuild"
  value       = aws_iam_role.codebuild.name
}