# Convert all Datadog monitors from YAML config to Terraform map
module "datadog_monitors_yaml_config" {
  source  = "cloudposse/config/yaml"
  version = "0.2.0"

  map_config_local_base_path = path.module
  map_config_paths           = var.datadog_monitors_config_paths

  context = module.this.context
}

module "datadog_monitors" {
  source  = "cloudposse/monitor/datadog"
  version = "0.9.0"

  datadog_monitors     = module.datadog_monitors_yaml_config.map_configs
  alert_tags           = var.alert_tags
  alert_tags_separator = var.alert_tags_separator

  context = module.this.context
}

locals {
  datadog_api_key = var.secrets_store_type == "ASM" ? data.aws_secretsmanager_secret_version.datadog_api_key[0].secret_string : data.aws_ssm_parameter.datadog_api_key[0].value
  datadog_app_key = var.secrets_store_type == "ASM" ? data.aws_secretsmanager_secret_version.datadog_app_key[0].secret_string : data.aws_ssm_parameter.datadog_app_key[0].value
}
