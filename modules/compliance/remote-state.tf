module "account_map" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.13.0"

  stack_config_local_path = "../../../stacks"
  component               = "account-map"
  environment             = var.global_environment_name
  stage                   = var.root_account_stage_name
  privileged              = var.privileged

  context = module.this.context
}
