module "s3" {
	source = "./modules/s3"
	lf_arn = module.lambda.lf_arn
}

module "lambda" {
	source = "./modules/lambda_function"
}
