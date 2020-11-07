
# Function
resource "aws_lambda_function" "lambda" {
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  function_name = var.name
  role          = aws_iam_role.lambda_role.arn
  handler       = var.handler
  runtime       = var.runtime
  memory_size   = var.memory
  timeout       = var.timeout

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # source_code_hash = base64sha256(file("lambda.zip"))
  # source_code_hash = filebase64sha256(var.filename)

  dynamic "environment" {
    for_each = var.environment == null ? [] : [var.environment]
    content {
      variables = var.environment
    }
  }
  depends_on = [aws_cloudwatch_log_group.lambda_cloudwatch]
}

# Permission to access API GW
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${var.apigw_execution_arn}/*/*/*"
  #   depends_on    = ["aws_api_gateway_rest_api.api", "aws_api_gateway_resource.proxy"]
}

# IAM role
resource "aws_iam_role" "lambda_role" {
  name = "${var.name}_lambda_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
resource "aws_cloudwatch_log_group" "lambda_cloudwatch" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = var.log_retention_in_days
}

resource "aws_iam_policy" "lambda_logging" {
  count = var.log_retention_in_days > 0 ? 1 : 0

  name        = "${var.name}lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logging_attachment" {
  count = var.log_retention_in_days > 0 ? 1 : 0

  role       = join("", aws_iam_role.lambda_role.*.name)
  policy_arn = join("", aws_iam_policy.lambda_logging.*.arn)
}

# Role attached to Lambda
resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.name}_lambda_policy"
  path        = "/"
  description = "IAM policy for attach to lambda"

  policy = var.lambda_policy
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
