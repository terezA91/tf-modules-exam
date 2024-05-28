module "s3" {
	source = "./modules/s3"
	object_source = "~/m-index.html"
	#lf_arn = module.lambda.lf_arn
}

module "cf_distribution" {
	source = "./modules/cloudfront"
	s3_bucket_name = module.s3.s3_bucket_name
	origin_domain_name = module.s3.domain_name
	origin_id = module.s3.origin_id
	s3_bucket_arn = module.s3.bucket_arn
}

/*
module "lambda" {
	source = "./modules/lambda_function"
	bucket_arn = module.s3.bucket_arn
}

module "vpc" {
	source = "./modules/vpc" 
}
*/
