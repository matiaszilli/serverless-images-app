variable "name" {
  description = "The name of the REST API"
  type        = string
}

variable "stage_name" {
  description = "The stage name for the API deployment (production/staging/etc..)"
  type        = string
}

variable "functions" {
  description = "A list of functions to attach to"
  type = list(object({
    method     = string
    lambda_arn = string
  }))
}

variable "path_part" {
  description = "Resource path_part"
  type        = string
}
