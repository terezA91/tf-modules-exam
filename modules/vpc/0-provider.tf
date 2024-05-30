provider "aws" {
	region = "eu-north-1"
}

/*
terraform {
	required_version = ">= 1.0"

	backend "local" {
		path = var.backend_path
	}

	required_providers {
		aws = {
			source = "hashicorp/aws"
			version = var.provider_version
		}
	}
}
*/
