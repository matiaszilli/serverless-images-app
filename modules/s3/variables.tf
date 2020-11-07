variable "name" {
  description = "Bucket name (it has to be unique globally)"
  type        = string
  default     = ""
}

variable "name_replication" {
  description = "Replication backup Bucket name (it has to be unique globally)"
  type        = string
  default     = ""
}

variable "lifecycle_enabled" {
  description = "Enable lifecycle object expiration"
  type        = string
  default     = false
}

variable "replication_curr_obj_expiration" {
  description = "Specifies when a current object version expires in replication bucket"
  type        = number
  default     = 30
}
variable "replication_noncurr_obj_expiration" {
  description = "Specifies when a noncurrent object version expires in replication bucket"
  type        = number
  default     = 30
}

variable "curr_obj_expiration" {
  description = "Specifies when a current object version expires in origin bucket"
  type        = number
  default     = 30
}

variable "noncurr_obj_expiration" {
  description = "Specifies when a noncurrent object version expires in origin bucket"
  type        = number
  default     = 30
}

variable "policy" {
  description = "Bucket policy"
  type        = string
  default     = ""
}
