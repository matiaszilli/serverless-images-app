output "api_url" {
  description = "The URL to invoke the API pointing to the stage. e.g. https://z4675bid1j.execute-api.eu-west-2.amazonaws.com/prod"
  value       = "${aws_api_gateway_deployment.deployment.invoke_url}/${var.path_part}"
}

output "execution_arn" {
  description = "The execution ARN to be used in lambda_permission's source_arn when allowing API Gateway to invoke a Lambda function"
  value       = aws_api_gateway_rest_api.api.execution_arn
}

output "http_methods" {
  description = "The HTTP method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)"
  value       = aws_api_gateway_integration_response.response_method_integration.*.http_method
}
