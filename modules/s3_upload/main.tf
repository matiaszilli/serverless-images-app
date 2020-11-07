
# Upload files S3
resource "aws_s3_bucket_object" "upload" {
  bucket = var.bucket_name
  key    = var.s3_key
  source = "${path.root}/${var.file_source}"

  # The filemd5() function is available in Terraform 0.11.12 and later
  etag = filemd5("${path.root}/${var.file_source}")
}
