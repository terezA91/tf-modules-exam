provider "aws" {
	region = "eu-north-1"
	profile = "default"
}

resource "aws_s3_bucket" "b1" {
	bucket = var.bucket_name
	#bucket_prefix = "helma"  //for unique bucket_name
	force_destroy = var.destroy_bucket
	
	tags = {
		Name = "Custom bucket"
	}
}

resource "aws_s3_bucket_public_access_block" "exam" {
	bucket = aws_s3_bucket.b1.id
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

resource "aws_s3_bucket_website_configuration" "web" {
	count = var.as_website == true ? 1 : 0  
	bucket = aws_s3_bucket.b1.id
	index_document {
		suffix = "index.html"
	}
}

resource "aws_s3_object" "ob" {
	bucket = aws_s3_bucket.id
	source = var.object_source
	key = var.object_name
}

/*ver
resource "aws_s3_bucket_notification" "bn" {
	bucket = aws_s3_bucket.b1.id
	lambda_function {
		lambda_function_arn = var.lf_arn
		events = ["s3:ObjectCreated:*"]
	}
}
*/

resource "aws_s3_bucket_accelerate_configuration" "s1" {
	bucket = aws_s3_bucket.b1.id
	status = "Suspended"  //or <Enabled> 
}

/*
resource "aws_s3_directory_bucket" "db" {
	bucket = "example--usw2-az1--x-s3"
	location {
		name = var.az[1]
	}
  //Bucket name must be in the following format
	//[bucket_name]--[azid]--x-s3
}

resource "aws_s3_bucket_ownership_controls" "s1" {
	bucket = aws_s3_bucket.b1.id
	rule {
		object_ownership = "BucketOwnerPreferred"
		#object_ownership = "ObjectWriter"
	}
}
