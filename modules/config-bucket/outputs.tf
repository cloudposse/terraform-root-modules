output "config_bucket_domain_name" {
  value       = module.config_s3_bucket.bucket_domain_name
  description = "Config S3 bucket domain name"
}

output "config_bucket_id" {
  value       = module.config_s3_bucket.bucket_id
  description = "Config S3 bucket ID"
}

output "config_bucket_arn" {
  value       = module.config_s3_bucket.bucket_arn
  description = "Config S3 bucket ARN"
}
