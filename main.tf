module "s3" {
	source = "./modules/s3"
/*lambda section
  trigger_lambda = true
	lf_arn = module.lambda.lf_arn
	lf_permission = module.lambda.lf_permission
*/
		
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
