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
  source           = "../modules/lambda"
  aws_region       = var.aws_region
  lambda_name      = "${var.resource_prefix}-ts-esbuild-lambda"
  lambda_role_name = "${var.resource_prefix}-ts-esbuild-lambda-role"
  lambda_handler   = "index.handler"
  lambda_runtime   = "nodejs20.x"
  lambda_zip_path  = "./lambdas/ts-esbuild/dist/app.zip"
}

module "java_lambda_module" {
  source           = "../modules/lambda"
  aws_region       = var.aws_region
  lambda_name      = "${var.resource_prefix}-java-lambda"
  lambda_role_name = "${var.resource_prefix}-java-lambda-role"
  lambda_handler   = "App"
  lambda_runtime   = "java21"
  lambda_zip_path  = "./lambdas/java/target/app.jar"
}

module "go_lambda_module" {
  source           = "../modules/lambda"
  aws_region       = var.aws_region
  lambda_name      = "${var.resource_prefix}-go-lambda"
  lambda_role_name = "${var.resource_prefix}-go-lambda-role"
  lambda_handler   = "bootstrap"
  lambda_runtime   = "provided.al2023"
  lambda_zip_path  = "./lambdas/go/bin/app.zip"
}


module "python_lambda_module" {
  source           = "../modules/lambda"
  aws_region       = var.aws_region
  lambda_name      = "${var.resource_prefix}-python-lambda"
  lambda_role_name = "${var.resource_prefix}-python-lambda-role"
  lambda_handler   = "app.lambda_handler"
  lambda_runtime   = "python3.12"
  lambda_zip_path  = "./lambdas/python/dist/app.zip"
}

module "dotnet_lambda_module" {
  source           = "../modules/lambda"
  aws_region       = var.aws_region
  lambda_name      = "${var.resource_prefix}-dotnet-lambda"
  lambda_role_name = "${var.resource_prefix}-dotnet-lambda-role"
  lambda_handler   = "MyDotNetLambda::MyDotNetLambda.Function::FunctionHandler"
  lambda_runtime   = "dotnet8"
  lambda_zip_path  = "./lambdas/dotnet/bin/Release/net8.0/app.zip"
}

module "kotlin_lambda_module" {
  source           = "../modules/lambda"
  aws_region       = var.aws_region
  lambda_name      = "${var.resource_prefix}-kotlin-lambda"
  lambda_role_name = "${var.resource_prefix}-kotlin-lambda-role"
  lambda_handler   = "com.example.AppKt::handleRequest"
  lambda_runtime   = "java21"
  lambda_zip_path  = "./lambdas/kotlin/build/libs/kotlin.jar"
}
