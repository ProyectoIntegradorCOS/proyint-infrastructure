terraform {
  backend "s3" {
    bucket         = "dmc-final-terrastate-app"
    key            = "thaqhiri/staging/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "thaqhiri-terraform-locks"
    encrypt        = true
    profile        = "dmc_final"
  }
}
