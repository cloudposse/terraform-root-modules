provider "spacelift" {}

locals {
  config_filenames   = fileset("../../../stacks", "*.yaml")
  stack_config_files = [for f in local.config_filenames : f if(replace(f, "globals", "") == f)]
}

module "spacelift" {
  source  = "cloudposse/cloud-infrastructure-automation/spacelift"
  version = "0.11.1"

  branch             = var.git_branch
  components_path    = "components/terraform"
  manage_state       = false
  repository         = var.git_repository
  runner_image       = var.runner_image
  stack_config_files = local.stack_config_files
  stack_config_path  = "../../../stacks"
  worker_pool_id     = var.worker_pool_id

  # Global defaults for all Spacelift stacks created by this project.
  terraform_version = var.terraform_version
  autodeploy        = var.autodeploy

  terraform_version_map = var.terraform_version_map
}
