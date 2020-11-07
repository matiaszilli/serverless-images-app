output "id" {
  description = "The ID of the Security Group"
  value       = aws_security_group.this.*.id
}

output "arn" {
  description = "The ARN of the Security Group"
  value       = join("", aws_security_group.this.*.arn)
}

output "name" {
  description = "The name of the Security Group"
  value       = join("", aws_security_group.this.*.name)
}

output "owner_id" {
  description = "The owner ID of the Security Group"
  value       = join("", aws_security_group.this.*.owner_id)
}
