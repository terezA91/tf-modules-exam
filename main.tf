module "s3" {
	#source = "./modules/s3"
	lf_arn = module.lambda.lf_arn
	source = lf_arn == "fg" ? ".modules/" : "./modules/s3"
}

module "lambda" {
	source = "./modules/lambda_function"
	bucket_arn = module.s3.bucket_arn
}
