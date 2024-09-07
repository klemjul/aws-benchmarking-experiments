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
  source      = "./lambdas/ts-esbuild"
  aws_region  = var.aws_region
  lambda_name = "${var.resource_prefix}-ts-esbuild-lambda"
  role_name   = "${var.resource_prefix}-ts-esbuild-lambda-role"
}
