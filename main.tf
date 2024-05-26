module "s3" {
	source = "./modules/s3"
	object_source = "~/m-index.html"
	#lf_arn = module.lambda.lf_arn
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
