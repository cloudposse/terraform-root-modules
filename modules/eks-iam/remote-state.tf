module "eks" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.13.0"

  component               = "eks"
  stack_config_local_path = "../../../stacks"

  context = module.this.context
}

module "account_map" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.13.0"

  component               = "account-map"
  environment             = var.account_map_environment_name
  stack_config_local_path = "../../../stacks"
  stage                   = var.account_map_stage_name

  context = module.this.context
}

module "dns_delegated" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.13.0"

  component               = "dns-delegated"
  stack_config_local_path = "../../../stacks"

  context = module.this.context
}

module "dns_gbl_delegated" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.13.0"

  component               = "dns-delegated"
  environment             = var.dns_gbl_delegated_environment_name
  stack_config_local_path = "../../../stacks"

  context = module.this.context
}

module "iam_primary_roles" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.13.0"

  component               = "iam-primary-roles"
  environment             = var.iam_primary_roles_environment_name
  stack_config_local_path = "../../../stacks"
  stage                   = var.iam_primary_roles_stage_name

  context = module.this.context
}

locals {
  default_dns_zone_id = module.dns_delegated.outputs.default_dns_zone_id

  zone_ids = compact(concat(
    values(module.dns_delegated.outputs.zones)[*].zone_id,
    values(module.dns_gbl_delegated.outputs.zones)[*].zone_id
  ))
}
