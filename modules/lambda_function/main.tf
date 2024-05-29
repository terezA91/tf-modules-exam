locals {
	file_name = "file"
}

provider "aws" {
	region = "eu-north-1" 
	profile = "default"
}

resource "aws_iam_role" "for-lambda-t" {
	name = "role-for-lambda"
	assume_role_policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Sid = "iamRoleForLambda"
				Effect = "Allow"
				Action = "sts:AssumeRole"
				Principal = {
					Service = "lambda.amazonaws.com"
				}
			},
		]
	})
	tags = {
		Name = "Role for lamnda"			
	}
}

resource "aws_iam_policy" "access-to-cloudwatch" {
	name = "AccessToCloudWatch-t"
	description = "some-desc"
	policy = jsonencode({
		Version = "2012-10-17"
		Statement = [
			{
				Effect = "Allow"
				Action = [
					"logs:CreateLogGroup",
					"logs:GreateLogStream",
					"logs:PutLogEvents"
				]
				Resource = "arn:aws:logs:*:*:*"
			},
		]
	})
}

resource "aws_iam_role_policy_attachment" "rp-attach" {
	role = aws_iam_role.for-lambda-t.name
	policy_arn = aws_iam_policy.access-to-cloudwatch.arn
}

data "archive_file" "zip-of-content" {
	type = "zip"
	source_dir = "${path.module}/${var.source_dir}/"
	output_path = "${path.module}/${var.source_dir}/file.zip"
}

resource "aws_lambda_function" "tf-lambda-up" {
	function_name = "tf-lambda"
	filename = "${path.module}/${var.source_dir}/${local.file_name}.zip"
	role = aws_iam_role.for-lambda-t.arn
	handler = "${local.file_name}.lambda_handler"
	runtime = var.runtime_lang	
}

resource "aws_lambda_permission" "alp" {
	statement_id = "AllowExecutionFromS3"
	action = "lambda:InvokeFunction"
	function_name = aws_lambda_function.tf-lambda-up.arn
	principal = "s3.amazonaws.com"
	source_arn = var.bucket_arn 
}

resource "null_resource" "wait_for_lambda_trigger" {
  depends_on   = [aws_lambda_permission.alp]
  provisioner "local-exec" {
    command = "sleep 3m"
  }
}
