variable "name" {
  description = "Solution name, e.g. 'app' or 'jenkins'"
  type        = string
  default     = "dynamotablename"
}

variable "write_capacity" {
  description = "DynamoDB write capacity"
  type        = number
  default     = 1
}

variable "read_capacity" {
  description = "DynamoDB read capacity"
  type        = number
  default     = 1
}

variable "hash_key" {
  description = "DynamoDB table Hash Key"
  type        = string
}

variable "hash_key_type" {
  description = "Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
  type        = string
  default     = "S"
}

variable "range_key" {
  description = "DynamoDB table Range Key"
  type        = string
  default     = "defaultrangekey"
}

variable "range_key_type" {
  description = "Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data"
  type        = string
  default     = "S"
}
