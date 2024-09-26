/**
* Terraform backend configuration
* - Create S3 bucket and dynamodb table for terraform state before initializing terraform
*
* S3 Configuration
* - It's better to create the s3 manually
* - Enable versioning
* - Enable cross-region cross-account replication (recommended)
* - Enable MFA delete (recommended)
* - Enable server-side encryption (optional)
* Follow terraform documentation for more details
* @see https://www.terraform.io/docs/backends/types/s3.html
*
* DynamoDB Configuration
* Though it optional for terraform state locking, it's recommended to use it.
* It helps to prevent concurrent writes to the terraform state file.
* - It's better to create the dynamodb table manually
* - Create a dynamodb table with the following attributes
*   - Partition key: LockID (String)
* Refer terraform documentation for more details
* @see https://developer.hashicorp.com/terraform/language/backend/s3#dynamodb-table-permissions

* Do NOT uncomment the following block. Instead, provide the values via CLI or environment variables
*
* 1. For CLI, use the following command:
* terraform init -backend-config="bucket=<your-terraform-state-bucket>" \
-backend-config="key=<path/to/your/terraform.tfstate>" \
-backend-config="region=<us-west-2>" \
-backend-config="encrypt=true" \
-backend-config="dynamodb_table=<your-terraform-state-lock-table>" \
--profile "<your-aws-profile>"
*
* 2. For environment variables, use the following:
* export TF_CLI_ARGS_init="-backend-config=bucket=<your-terraform-state-bucket> -backend-config=key=<path/to/your/terraform.tfstate> -backend-config=region=<us-west-2> -backend-config=encrypt=true -backend-config=dynamodb_table=<your-terraform-state-lock-table>"
*/

terraform {
  backend "s3" {
    # These values should be provided via CLI or environment variables
    # bucket         = "your-terraform-state-bucket"
    # key            = "path/to/your/terraform.tfstate"
    # region         = "us-west-2"
    # encrypt        = true
    # dynamodb_table = "your-terraform-state-lock-table"
  }
}