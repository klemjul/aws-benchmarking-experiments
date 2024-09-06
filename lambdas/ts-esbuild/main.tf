provider "aws" {
  region = var.aws_region
}

# IAM Role for Lambda execution
resource "aws_iam_role" "lambda_execution_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Build and Zip Lambda Function
resource "null_resource" "build_and_zip_lambda" {
  provisioner "local-exec" {
    command = <<EOT
      npm install --prefix ${path.module}  # Install dependencies
      npm build
      zip -r ${path.module}/dist/app.zip ${path.module}/dist/app*
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

# Lambda function resource
resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"

  filename = "${path.module}/dist/app.zip"

  depends_on = [null_resource.build_and_zip_lambda]
}

