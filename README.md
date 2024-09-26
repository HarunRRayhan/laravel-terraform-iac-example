# Laravel AWS Infrastructure

This project contains Terraform configurations to deploy a scalable and secure Laravel application infrastructure on
AWS. It sets up a complete CI/CD pipeline and uses AWS services such as EC2, RDS, S3, CloudFront, and more.

## Features

- Auto Scaling Group for EC2 instances
- Application Load Balancer
- RDS MySQL database
- S3 bucket for static assets
- CloudFront distribution
- CodePipeline with GitHub integration
- CodeBuild and CodeDeploy for CI/CD
- Secrets management using AWS Secrets Manager
- SSL/TLS support using ACM
- Route53 for DNS management

## Prerequisites

- Terraform v1.9.0 or newer
- AWS CLI configured with appropriate credentials
- GitHub repository with your Laravel application (use this repo in GitHub/Bitbucket/GitLab workflow)

## Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/HarunRRayhan/laravel-terraform-iac-example.git
   cd laravel-terraform-iac-example
   ```

2. Copy `env.example.tfvars` to `env.tfvars` and fill in the variables:
   ```hcl
   env_variables = {
     APP_ENV     = "production"
     APP_KEY     = "base64:your-app-key-here"
     APP_DEBUG   = "false"
     LOG_CHANNEL = "stack"
     # Add any other necessary environment variables
   }
   ```

3. Initialize Terraform:
   ```bash
   terraform init \
     -backend-config="bucket=your-terraform-state-bucket" \
     -backend-config="key=path/to/your/terraform.tfstate" \
     -backend-config="region=us-west-2" \
     -backend-config="encrypt=true" \
     -backend-config="dynamodb_table=your-terraform-state-lock-table"
   ```
   Replace the values with your actual S3 bucket name, desired state file path, region, and DynamoDB table name for
   state locking.

4. Review the planned changes:
   ```bash
   terraform plan -var-file="env.tfvars" 
   ```

5. Apply the Terraform configuration:
   ```bash
   terraform apply -var-file="env.tfvars" 
   ```

6. After the infrastructure is created, complete the GitHub connection in the AWS CodePipeline console.

## Customization

You can fork this repository and customize various aspects of the infrastructure by modifying the Terraform variables.

## Maintenance

- To update the infrastructure, modify the Terraform files and run `terraform apply` again.
- To destroy the infrastructure, run `terraform destroy`.

## Security

- Ensure that you keep your `env.tfvars` file and Terraform state secure, as they contain sensitive information.
- Regularly update the AMI and other components to receive the latest security patches.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.