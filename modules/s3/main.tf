provider "aws" {
	region = "eu-north-1"
	profile = "default"
}

resource "aws_s3_bucket" "b1" {
	bucket = var.bucket_name
	force_destroy = var.destroy_bucket
	
	tags = {
		Name = "Custom bucket"
	}
}

resource "aws_s3_bucket_public_access_block" "exam" {
	block_public_acls = true  //default value
	block_public_policy = var.s3_block_public_policy
	ignore_public_acls = true  //default value
	restrict_public_buckets = var.s3_restrict_public_buckets
}

resource "aws_s3_bucket_versioning" "bv" {
	bucket = aws_s3_bucket.b1.id
	versioning_configuration {
		status = var.enable_versioning[0]
	}
}
