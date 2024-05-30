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
		Name = "Role for lambda"			
	}
}

resource "aws_cloudwatch_log_group" "lf-loggroup" {
  name = "/aws/lambda/${aws_lambda_function.tf-lambda-up.function_name}"
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.lf-loggroup.arn,
      "${aws_cloudwatch_log_group.lf-loggroup.arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "ts_lambda_role_policy" {
  policy = data.aws_iam_policy_document.policy.json
  role   = aws_iam_role.for-lambda-t.id
  name   = "my-lambda-policy"
}

/*
resource "aws_iam_policy" "access-to-cloudwatch" {
  name = "AccessToCloudWatch"
  description = "Access to CloudWatch"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "logs:CreateLogGroup",
        "Resource": "arn:aws:logs:eu-north-1:983119644965:*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": [
          "arn:aws:logs:eu-north-1:983119644965:log-group:/aws/lambda/tf-lambda:*"
        ]
      }
    ]
  })
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
					"logs:CreateLogStream",
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
*/

data "archive_file" "zip-of-content" {
	type = "zip"
	source_dir = "${path.module}/${var.source_dir}/"
	output_path = "${path.module}/${var.source_dir}/file.zip"
}

resource "aws_lambda_function" "tf-lambda-up" {
	function_name = "tf-lambda"
	filename = "${path.module}/${var.source_dir}/file.zip"
	role = aws_iam_role.for-lambda-t.arn
	#ver handler = "${local.file_name}.lambda_handler"
	handler = "file.lambda_handler"
	runtime = var.runtime_lang	
}

resource "aws_lambda_permission" "alp" {
	statement_id = "AllowExecutionFromS3"
	action = "lambda:InvokeFunction"
	function_name = aws_lambda_function.tf-lambda-up.arn
	principal = "s3.amazonaws.com"
	source_arn = var.bucket_arn 
}

/*
resource "null_resource" "wait_for_lambda_trigger" {
  depends_on   = [aws_lambda_function.tf-lambda-up]
  provisioner "local-exec" {
    command = "sleep 1m"
  }
}
*/
