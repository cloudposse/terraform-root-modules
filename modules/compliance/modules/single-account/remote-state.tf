module "config_bucket" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.13.0"

  stack_config_local_path = "../../../stacks"
  component               = "config-bucket"
  stage                   = var.config_bucket_stage
  environment             = var.config_bucket_env
  privileged              = false

  context = module.this.context
}

module "cloudtrail_bucket" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.13.0"

  stack_config_local_path = "../../../stacks"
  component               = "cloudtrail-bucket"
  stage                   = var.cloudtrail_bucket_stage
  environment             = var.cloudtrail_bucket_env
  privileged              = false

  context = module.this.context
}
