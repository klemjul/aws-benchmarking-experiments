variable "aws_region" {
  type        = string
  description = "AWS Region to deploy the Lambda"
}

variable "lambda_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "lambda_role_name" {
  type        = string
  description = "Name of the Lambda function IAM role"
}

variable "lambda_zip_path" {
  type        = string
  description = "Location of the lambda zip archive"
}

variable "lambda_runtime" {
  type        = string
  description = "allowed aws lambda runtime for the lambda"
}

variable "lambda_handler" {
  type = string
}
