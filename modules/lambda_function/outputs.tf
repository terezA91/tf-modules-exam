output "lf_arn" {
    value = aws_lambda_function.tf-lambda-up.arn
    description = "Arn of lambda function"
}