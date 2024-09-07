terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66"
    }
  }

  backend "s3" {
    key = "terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
}


module "javascript_lambda_module" {
  source           = "./modules/lambda"
  aws_region       = var.aws_region
  lambda_name      = "${var.resource_prefix}-ts-esbuild-lambda"
  lambda_role_name = "${var.resource_prefix}-ts-esbuild-lambda-role"
  lambda_handler   = "index.handler"
  lambda_runtime   = "nodejs20.x"
  lambda_zip_path  = "./lambdas/ts-esbuild/dist/app.zip"
}

module "java_lambda_module" {
  source           = "./modules/lambda"
  aws_region       = var.aws_region
  lambda_name      = "${var.resource_prefix}-java-lambda"
  lambda_role_name = "${var.resource_prefix}-java-lambda-role"
  lambda_handler   = "App"
  lambda_runtime   = "java21"
  lambda_zip_path  = "./lambdas/java/target/app.jar"
}
