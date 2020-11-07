
# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name               = var.name
  binary_media_types = ["multipart/form-data"]
}

# Resource
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.path_part
}

# Methods
resource "aws_api_gateway_method" "request_method" {
  count = length(var.functions)

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = lookup(
    var.functions[count.index],
    "method"
  )
  authorization = "NONE"
}

# Lambda integration requests
resource "aws_api_gateway_integration" "request_method_integration" {
  count = length(var.functions)

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = lookup(
    var.functions[count.index],
    "method"
  )
  uri = lookup(
    var.functions[count.index],
    "lambda_arn"
  )

  # AWS lambdas can only be invoked with the POST method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
}

# Lambda integration response: lambda => GET response
resource "aws_api_gateway_method_response" "response_method" {
  count = length(var.functions)

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = lookup(
    var.functions[count.index],
    "method"
  )
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "response_method_integration" {
  count = length(var.functions)

  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = lookup(
    var.functions[count.index],
    "method"
  )
  status_code = aws_api_gateway_method_response.response_method[count.index].status_code

  response_templates = {
    "application/json" = ""
  }
}

# Deployment
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.stage_name
  depends_on  = ["aws_api_gateway_integration.request_method_integration", "aws_api_gateway_integration_response.response_method_integration"]
}
