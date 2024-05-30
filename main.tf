module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2_instance"

	pub_sub_a_id = module.vpc.pub_sub_a_id
	sec_group_id = module.vpc.sec_group_id	
	sh_file      = "docker_install.sh"
}

/*
module "s3" {
	source = "./modules/s3"

# >>>Lambda portion
#	trigger_lambda = true
#	f_arn          = module.lambda.lf_arn
#	lf_permission  = module.lambda.lf_permission
#	>>>CloudFront portion
#	cf_name       = module.cf_distribution.cf_name
#	policy_for_cf = module.cf_distribution.policy_for_cf		

}

module "cf_distribution" {
  source = "./modules/cloudfront"

  s3_bucket_name     = module.s3.s3_bucket_name
  origin_domain_name = module.s3.domain_name
  origin_id          = module.s3.origin_id
  s3_bucket_arn      = module.s3.bucket_arn
}

module "lambda" {
  source = "./modules/lambda_function"

  bucket_arn = module.s3.bucket_arn
}

*/
