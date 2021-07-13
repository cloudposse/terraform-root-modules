module "aws_config" {
  source  = "cloudposse/config/aws"
  version = "0.7.2"

  s3_bucket_id  = local.s3_bucket.config_bucket_id
  s3_bucket_arn = local.s3_bucket.config_bucket_arn

  create_iam_role  = var.create_iam_role
  iam_role_arn     = var.iam_role_arn
  create_sns_topic = true
  managed_rules    = local.enabled_rules

  global_resource_collector_region   = var.global_resource_collector_region
  central_resource_collector_account = var.central_resource_collector_account
  child_resource_collector_accounts  = var.child_resource_collector_accounts

  context = module.this.context
}

module "cis_1_2" {
  source  = "cloudposse/config/aws//modules/cis-1-2-rules"
  version = "0.7.2"

  is_logging_account     = var.is_logging_account
  support_policy_arn     = "arn:aws:iam::432824148855:role/aws-service-role/support.amazonaws.com/AWSServiceRoleForSupport"
  cloudtrail_bucket_name = local.cloudtrail_bucket.cloudtrail_bucket_id
  config_rules_paths     = var.config_rules_paths

  context = module.this.context
}

module "hipaa_conformance_pack" {
  source  = "cloudposse/config/aws//modules/conformance-pack"
  version = "0.8.0"

  conformance_pack = "https://raw.githubusercontent.com/awslabs/aws-config-rules/master/aws-config-conformance-packs/Operational-Best-Practices-for-HIPAA-Security.yaml"

  context = module.this.context
}

module "security-hub" {
  source  = "cloudposse/security-hub/aws"
  version = "0.4.4"

  enabled = module.this.stage == var.securityhub_central_account

  create_sns_topic  = var.securityhub_create_sns_topic
  enabled_standards = var.securityhub_enabled_standards

  context = module.this.context
}

locals {
  s3_bucket = module.config_bucket.outputs
}

locals {
  cloudtrail_bucket = module.cloudtrail_bucket.outputs
  enabled_rules     = merge(local.cis_1_2_rules)
  cis_1_2_rules     = module.cis_1_2.rules
}
