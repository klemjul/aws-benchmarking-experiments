
# API Gateway Resource
resource "aws_api_gateway_resource" "lambda_resource" {
  rest_api_id = var.apigw_id
  parent_id   = var.apigw_root_resource_id
  path_part   = var.path
}

# API Gateway Method
resource "aws_api_gateway_method" "lambda_method" {
  rest_api_id   = var.apigw_id
  resource_id   = aws_api_gateway_resource.lambda_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# API Gateway Integration
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = var.apigw_id
  resource_id             = aws_api_gateway_resource.lambda_resource.id
  http_method             = aws_api_gateway_method.lambda_method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = var.lambda_invoke_arn
}

# API Gateway Invoke Permission for Lambda
resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.apigw_execution_arn}/*/GET/${var.path}"
}
