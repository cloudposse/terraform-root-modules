module "dns_delegated" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.13.0"

  stack_config_local_path = "../../../stacks"
  component               = "dns-delegated"

  context = module.this.context
}
