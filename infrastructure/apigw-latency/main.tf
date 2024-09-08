terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66"
    }
  }

  backend "s3" {
    key = "terraform.apigw-latency.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}

module "go_lambda_module" {
  source           = "../modules/lambda"
  aws_region       = var.aws_region
  lambda_name      = "${var.resource_prefix}-go-apigw-lambda"
  lambda_role_name = "${var.resource_prefix}-go-apigw-lambda-role"
  lambda_handler   = "bootstrap"
  lambda_runtime   = "provided.al2023"
  lambda_zip_path  = "./lambdas/go-apigw/bin/app.zip"
}


# API Gateway
resource "aws_api_gateway_rest_api" "apigw" {
  name        = "${var.resource_prefix}-apigateway"
  description = "API Gateway for various benchmarking tests"
}

module "javascript_apigw_integration" {
  source                 = "../modules/api_gateway_lambda_route"
  apigw_execution_arn    = aws_api_gateway_rest_api.apigw.execution_arn
  apigw_id               = aws_api_gateway_rest_api.apigw.id
  apigw_root_resource_id = aws_api_gateway_rest_api.apigw.root_resource_id
  lambda_function_name   = module.go_lambda_module.lambda_function_name
  lambda_invoke_arn      = module.go_lambda_module.lambda_function_invoke_arn
  path                   = "go"
}


resource "aws_api_gateway_deployment" "apigw_deployment" {
  rest_api_id = aws_api_gateway_rest_api.apigw.id
  stage_name  = "test"

  depends_on = [
    module.javascript_apigw_integration
  ]
}
