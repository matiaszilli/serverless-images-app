variable "bucket_name" {
  description = "Bucket name"
  type        = string
  default     = ""
}

variable "s3_key" {
  description = "Key to assign to file in S3"
  type        = string
  default     = ""
}

variable "file_source" {
  description = "Filename to upload to S3"
  type        = string
  default     = ""
}
