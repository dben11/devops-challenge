variable "aws_region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Globally unique name for the S3 state bucket"
  type        = string
  # CHANGE THIS: use your initials + random suffix, e.g. "tfstate-dben-20261019"
}

variable "lock_table_name" {
  description = "Name of the DynamoDB lock table"
  type        = string
  default     = "terraform-locks"
}
