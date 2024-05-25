variable "bucket_name" {
	type = string
	description = "Name of the s3 bucket"
	default = "helma-543"
}

variable "bucket_prefix" {
	type = string
	default = "helma"
	description = "Creates a unique bucket name beginning with the specified prefix"
}

variable "destroy_bucket" {
	type = bool
	description = "Delete an bucket regardless of the presence of the object"
	default = true
}

variable "enable_versioning" {
	type = list(string)
	description = "Enable bucket versioning or not"
	default = ["Disabled", "Enabled", "Suspended"]
}

variable "as_website" {
	type = bool
	description = "Create a bucket as a website(default) or as a storage"
	default = true
}

variable "s3_block_public_policy" {
	type = bool
	description = "Block `public_policy` in s3 or not"
	default = false
}

variable "s3_restrict_public_buckets" {
	type = bool
	description = "Restrict public buckets in s3 or not"
	default = false
}

variable "lf_arn" {
	type = string
	description = "Arn of lambda function"
}
