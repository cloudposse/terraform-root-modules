module "account_map" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  component               = "account-map"
  environment             = var.account_map_environment_name
  stack_config_local_path = "../../../stacks"
  stage                   = var.account_map_stage_name
  privileged              = true

  context = module.this.context
}

module "primary_roles" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  component               = "iam-primary-roles"
  environment             = var.iam_roles_environment_name
  stack_config_local_path = "../../../stacks"
  stage                   = var.iam_primary_roles_stage_name
  privileged              = true

  context = module.this.context
}

module "tfstate" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  component               = "tfstate-backend"
  enabled                 = module.this.stage == var.tfstate_backend_stage_name
  environment             = var.tfstate_backend_environment_name
  privileged              = true
  stack_config_local_path = "../../../stacks"

  context = module.this.context
}
