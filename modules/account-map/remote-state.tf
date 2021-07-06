module "accounts" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  component               = "account"
  privileged              = true
  stack_config_local_path = "../../../stacks"

  context = module.this.context
}

module "account-map" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  component               = "account-map"
  privileged              = true
  stack_config_local_path = "../../../stacks"

  context = module.this.context
}
