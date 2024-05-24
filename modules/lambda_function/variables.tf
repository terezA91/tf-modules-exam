variable "source_dir" {
	type = string
	description = "Source directory of target file containing Lambda function"
	default = "../../python"
}

variable "runtime_lang" {
	type = string
	description = "Type and version of the runtime language"
	default = "python3.12"
}

variable "bucket_arn" {
	type = string
	description = "Arn of s3 bucket"
}
