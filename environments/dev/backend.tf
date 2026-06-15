# ANTES de hacer terraform init, crear manualmente en AWS:
# 1. Bucket S3:     aws s3api create-bucket --bucket thaqhiri-terraform-state --region us-east-1
# 2. DynamoDB:      aws dynamodb create-table --table-name thaqhiri-terraform-locks \
#                     --attribute-definitions AttributeName=LockID,AttributeType=S \
#                     --key-schema AttributeName=LockID,KeyType=HASH \
#                     --billing-mode PAY_PER_REQUEST --region us-east-1

terraform {
  backend "s3" {
    bucket         = "dmc-final-terrastate-app"
    key            = "thaqhiri/dev/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "thaqhiri-terraform-locks"
    encrypt        = true
    profile        = "dmc_final"
  }
}
