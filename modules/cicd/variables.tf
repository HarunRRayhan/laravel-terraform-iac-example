variable "application_name" {
  description = "Name of the application"
  type        = string
}

variable "git_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "git_branch" {
  description = "GitHub branch to use"
  type        = string
  default     = "main"
}

variable "environment" {
  description = "Deployment environment (e.g., production, staging)"
  type        = string
}

variable "secrets_arn" {
  description = "ARN of the secrets in AWS Secrets Manager"
  type        = string
}

