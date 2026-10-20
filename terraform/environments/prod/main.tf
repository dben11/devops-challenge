terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "../../modules/network"

  project_name = "devops-challenge"
  environment  = "prod"
}
module "ecs" {
  source = "../../modules/ecs"

  project_name      = "devops-challenge"
  environment       = "prod"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
}

# Output the VPC ID so we can see it
output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_ids" {
  value = module.network.public_subnet_ids
}

output "ecr_repository_url" {
  value = module.ecs.ecr_repository_url
}

output "alb_dns_name" {
  value = module.ecs.alb_dns_name
}
