terraform {
  required_version = "~> 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"

  application_name     = var.application_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "acm" {
  source          = "./modules/acm"
  domain_name     = var.domain_name
  route53_zone_id = var.route53_zone_id
}

module "alb" {
  source              = "./modules/alb"
  application_name    = var.application_name
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  acm_certificate_arn = module.acm.certificate_arn
}

module "cloudfront" {
  source                         = "./modules/cloudfront"
  application_name               = var.application_name
  domain_name                    = var.domain_name
  alb_dns_name                   = module.alb.alb_dns_name
  s3_bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  acm_certificate_arn            = module.acm.certificate_arn
  route53_zone_id                = var.route53_zone_id
}

module "s3" {
  source                                 = "./modules/s3"
  application_name                       = var.application_name
  cloudfront_origin_access_identity_path = module.cloudfront.origin_access_identity_path
}

module "rds" {
  source = "./modules/rds"
  application_name = var.application_name
  db_instance_class = var.db_instance_class
  db_name = var.db_name
  db_password = var.db_password
  db_username = var.db_username
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id = module.vpc.vpc_id
}

module "secrets" {
  source           = "./modules/secrets"
  application_name = var.application_name
  environment      = var.environment
  env_variables    = var.env_variables
  domain_name      = var.domain_name
  db_host          = module.rds.db_instance_address
  db_port          = module.rds.db_instance_port
  db_name          = var.db_name
  db_username      = var.db_username
  db_password      = var.db_password
}

module "cicd" {
  source           = "./modules/cicd"
  application_name = var.application_name
  secrets_arn      = module.secrets.secret_arn
  environment      = var.environment
  git_repo         = var.git_repo
  git_branch       = var.git_branch
}

module "ec2" {
  source                = "./modules/ec2"
  secrets_arn           = module.secrets.secret_arn
  alb_security_group_id = module.alb.security_group_id
  alb_target_group_arn  = module.alb.target_group_arn
  application_name      = var.application_name
  git_branch            = var.git_branch
  git_repo              = var.git_repo
  instance_type         = var.instance_type
  public_subnet_ids     = module.vpc.public_subnet_ids
  vpc_id                = module.vpc.vpc_id
}

# Create CodeBuild secrets policy
resource "aws_iam_role_policy" "codebuild_secrets_policy" {
  name = "${var.application_name}-codebuild-secrets-policy"
  role = module.cicd.codebuild_role_name

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = module.secrets.secret_arn
      }
    ]
  })
}

# Create EC2 secrets policy
resource "aws_iam_role_policy" "ec2_secrets_policy" {
  name = "${var.application_name}-ec2-secrets-policy"
  role = module.ec2.web_role_name

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = module.secrets.secret_arn
      }
    ]
  })
}