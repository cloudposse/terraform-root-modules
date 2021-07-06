module "eks_iam" {
  source  = "cloudposse/stack-config/yaml//modules/remote-state"
  version = "0.17.0"

  for_each = var.cicd_accounts

  component               = "eks-iam"
  stack_config_local_path = "../../../stacks"
  stage                   = each.value

  context = module.this.context
}
