module "s3" {
	source = "./modules/s3"
	count = 2
	lf_arn = module.lambda.lf_arn
}

module "lambda" {
	source = "./modules/lambda_function"
	bucket_arn = module.s3.bucket_arn
}
