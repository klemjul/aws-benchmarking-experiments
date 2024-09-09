variable "apigw_id" {
  type        = string
  description = "ID of Api Gateway to attach the lambda route"
}

variable "apigw_root_resource_id" {
  type        = string
  description = "Api Gateway resource to attach the lambda route"
}

variable "apigw_execution_arn" {
  type        = string
  description = "Api Gateway execution ARN"
}

variable "lambda_invoke_arn" {
  type        = string
  description = "Lambda Invoke ARN to integrate with the apigateway"
}

variable "lambda_function_name" {
  type        = string
  description = "Lambda name to integrate with the apigateway"

}

variable "path" {
  type        = string
  description = "Path under the provided apigw_root_resource_id for the integration"
}
