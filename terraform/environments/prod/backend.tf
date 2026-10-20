terraform {
  backend "s3" {
    bucket         = "tfstate-dben-20261019"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks" # Keep this! It works perfectly.
    encrypt        = true
  }
}
