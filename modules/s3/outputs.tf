output "arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = aws_s3_bucket.bucket.arn
}

output "id" {
  description = "The name of the bucket."
  value       = aws_s3_bucket.bucket.id
}

output "domain_name" {
  description = "The bucket domain name. Will be with format bucketname.s3.amazonaws.com."
  value       = element(concat(aws_s3_bucket.bucket.*.bucket_domain_name, list("")), 0)
}
