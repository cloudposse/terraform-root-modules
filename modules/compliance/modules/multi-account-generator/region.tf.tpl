#-----------------------------------------------------------------------------------------------------------------------
# DO NOT EDIT THIS FILE
# It has been automatically generated with the ../modules/multi-account-generator module
#-----------------------------------------------------------------------------------------------------------------------
provider "aws" {
  alias  = "${short}"
  region = "${region}"

  profile = coalesce(var.import_profile_name, module.iam_roles.terraform_profile_name)
}

module "compliance_${short}" {
  source = "./modules/single-account"
  providers = {
    aws = aws.${short}
  }

  enabled                            = contains(local.enabled_regions, "${region}")
  region                             = "${region}"
  config_bucket_stage                = var.config_bucket_stage
  config_bucket_env                  = var.config_bucket_env
  config_rules_paths                 = var.config_rules_paths
  global_resource_collector_region   = data.aws_region.this.name
  central_resource_collector_account = local.central_account
  child_resource_collector_accounts  = local.accounts
  securityhub_central_account        = var.securityhub_central_account
    
  is_logging_account      = data.aws_caller_identity.this.account_id == local.central_logging_account
  cloudtrail_bucket_stage = var.cloudtrail_bucket_stage
  cloudtrail_bucket_env   = var.cloudtrail_bucket_env

  create_iam_role = data.aws_region.this.name == "${region}"
  iam_role_arn    = data.aws_region.this.name == "${region}" ? null : local.config_iam_role_arn
  
  environment = "${short}"
  context     = module.this.context
}
