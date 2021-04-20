module "cloudtrail_bucket" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.13.0"

  stack_config_local_path = "../../../stacks"
  component               = "cloudtrail-bucket"
  environment             = var.cloudtrail_bucket_environment_name
  stage                   = var.cloudtrail_bucket_stage_name

  context = module.this.context
}
