module "datadog_integration" {
  source  = "cloudposse/datadog-integration/aws"
  version = "0.6.1"

  datadog_aws_account_id           = var.datadog_aws_account_id
  integrations                     = var.integrations
  filter_tags                      = var.filter_tags
  host_tags                        = var.host_tags
  excluded_regions                 = var.excluded_regions
  account_specific_namespace_rules = var.account_specific_namespace_rules

  context = module.this.context
}

locals {
  datadog_api_key = var.secrets_store_type == "ASM" ? data.aws_secretsmanager_secret_version.datadog_api_key[0].secret_string : data.aws_ssm_parameter.datadog_api_key[0].value
  datadog_app_key = var.secrets_store_type == "ASM" ? data.aws_secretsmanager_secret_version.datadog_app_key[0].secret_string : data.aws_ssm_parameter.datadog_app_key[0].value
}
