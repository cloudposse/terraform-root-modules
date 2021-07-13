module "requester_vpc" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.13.0"

  component               = "vpc"
  stack_config_local_path = "../../../stacks"

  context = module.this.context
}
