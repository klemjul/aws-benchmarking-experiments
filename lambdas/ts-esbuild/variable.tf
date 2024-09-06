variable "aws_region" {
  type        = string
  description = "AWS Region to deploy the Lambda"
}

variable "lambda_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "role_name" {
  type        = string
  description = "Name of the Lambda function IAM role"
}
