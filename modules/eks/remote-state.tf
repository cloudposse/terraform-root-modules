module "vpc" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  component               = "vpc"
  stack_config_local_path = "../../../stacks"

  context = module.this.context
}

module "primary_roles" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  component               = "iam-primary-roles"
  environment             = var.iam_roles_environment_name
  stack_config_local_path = "../../../stacks"
  stage                   = var.iam_primary_roles_stage_name

  context = module.this.context
}

module "delegated_roles" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  component               = "iam-delegated-roles"
  environment             = var.iam_roles_environment_name
  stack_config_local_path = "../../../stacks"

  context = module.this.context
}

module "workers_role" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  component = "eks-workers"
  defaults = {
    workers_role_arn = null
  }
  stack_config_local_path = "../../../stacks"

  context = module.this.context
}

# Yes, this is self-referential.
# It obtains the previous state of the cluster so that we can add
# to it rather than overwrite it (specifically the aws-auth configMap)
module "eks" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  component = "eks"
  defaults = {
    eks_managed_node_workers_role_arns = []
  }
  stack_config_local_path = "../../../stacks"

  context = module.this.context
}
