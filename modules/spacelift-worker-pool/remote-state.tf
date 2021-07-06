module "account_map" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  component               = "account-map"
  environment             = var.account_map_environment_name
  stack_config_local_path = "../../../stacks"
  stage                   = var.account_map_stage_name

  context = module.this.context
}

module "ecr" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  component               = "ecr-mutable"
  stack_config_local_path = "../../../stacks"
  stage                   = var.ecr_account_name

  context = module.this.context
}

module "vpc" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  component               = "vpc"
  stack_config_local_path = "../../../stacks"

  context = module.this.context
}
