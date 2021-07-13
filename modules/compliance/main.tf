module "iam_roles" {
  source  = "../account-map/modules/iam-roles"
  context = module.this.context
}

module "utils" {
  source  = "cloudposse/utils/aws"
  version = "0.2.0"
  context = module.this.context
}

module "aws_config_label" {
  source     = "cloudposse/label/null"
  version    = "0.22.0"
  attributes = ["config"]

  context = module.this.context
}

data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

locals {
  config_iam_role_arn     = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:role/${module.aws_config_label.id}"
  enabled_regions         = toset(length(var.enabled_regions) > 0 ? var.enabled_regions : module.utils.enabled_regions)
  account_map             = module.account_map.outputs.full_account_map
  accounts                = toset(values(local.account_map))
  central_account         = local.account_map[var.central_resource_collector_account]
  central_logging_account = local.account_map[var.central_logging_account]
}
