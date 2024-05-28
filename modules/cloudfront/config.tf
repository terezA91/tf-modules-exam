provider "aws" {
  region = "eu-north-1"
}

terraform {
  required_version = ">= 1.0"

  backend "local" {
    path = "~/tf-modules-exam/modules/cloudfront/terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.62"
    }
  }
}
