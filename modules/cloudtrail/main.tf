module "cloudtrail" {
  source  = "cloudposse/cloudtrail/aws"
  version = "0.19.0"

  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_cloudwatch_logs.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail_cloudwatch_logs.arn}:*"
  enable_logging                = var.enable_logging
  enable_log_file_validation    = var.enable_log_file_validation
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  s3_bucket_name                = module.cloudtrail_bucket.outputs.cloudtrail_bucket_id
  kms_key_arn                   = module.kms_key_cloudtrail.key_arn

  context = module.this.context
}
