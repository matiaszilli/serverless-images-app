variable "create_sg" {
  description = "Toggle controlling whether to create the security group"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the Security Group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID in which to create the Security Group"
  type        = string
}

variable "description" {
  description = "Description of the Security Group"
  type        = string
  default     = "Managed by Terraform"
}

variable "ingress_rules" {
  description = "A schema list of ingress rules for the Security Group, see <https://www.terraform.io/docs/providers/aws/r/security_group.html#ingress>"
  type        = list
  default     = []
}

variable "egress_rules" {
  description = "A schema list of egress rules for the Security Group, see <https://www.terraform.io/docs/providers/aws/r/security_group.html#egress>"
  type        = list
  default     = []
}

variable "revoke_rules_on_delete" {
  description = "Determines whether to forcibly remove rules when destroying the security group"
  type        = string
  default     = false
}

variable "tags" {
  description = "A map of tags for the Security Group"
  type        = map(string)
  default     = {}
}
