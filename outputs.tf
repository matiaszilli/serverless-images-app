output "http_methods" {
  description = "The HTTP method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)"
  value       = module.api_gw.http_methods
}

output "api_url" {
  description = "The URL to invoke the API pointing to the stage. e.g. https://z4675bid1j.execute-api.eu-west-2.amazonaws.com/prod"
  value       = module.api_gw.api_url
}

output "bucket_domainname" {
  description = "The bucket domain name. Will be with format bucketname.s3.amazonaws.com."
  value       = "https://${module.bucket_images.domain_name}"
}

