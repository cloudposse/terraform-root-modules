module "remote_vpc" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  stack_config_local_path = "../../../stacks"
  component               = "vpc"

  context = module.this.context
}

module "remote_dns" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  stack_config_local_path = "../../../stacks"
  component               = "dns-delegated"

  context = module.this.context
}