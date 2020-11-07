variable "name" {
  description = "Name  (e.g. `app` or `cluster`)."
  type        = string
  default     = "app"
}

variable "memory" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
  type        = number
  default     = 128
}

variable "handler" {
  description = "The function entrypoint in your code."
  type        = string
}

variable "s3_bucket" {
  description = "The S3 bucket location containing the function's deployment package."
  default     = null
}

variable "s3_key" {
  description = "The S3 key of an object containing the function's deployment package."
  default     = null
}

variable "runtime" {
  description = "Runtimes."
  type        = string
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 3."
  type        = number
  default     = 3
}

variable "apigw_execution_arn" {
  description = "API Gateway execution ARN."
  type        = string
}

variable "log_retention_in_days" {
  description = "Number of days of cloudwatch logs retention."
  type        = number
  default     = 0
}

variable "lambda_policy" {
  description = "Policy to attach to lambda function."
  type        = string
  default     = "{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Deny\", \"Action\": \"*\", \"Resource\":   \"*\"}}"
}

variable "environment" {
  description = "The Lambda environment's configuration settings."
  default     = null
  type        = map(string)
}
