module "forced" {
  source  = "cloudposse/label/null"
  version = "0.24.1"

  # account_map must always be enabled, even for components that are disabled
  enabled = true

  context = module.this.context
}

module "account_map" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  component               = "account-map"
  privileged              = var.privileged
  environment             = var.global_environment_name
  stack_config_local_path = "../../../stacks"
  stage                   = var.root_account_stage_name

  context = module.forced.context
}
