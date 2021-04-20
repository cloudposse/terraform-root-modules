# https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/
# https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html
# https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
# https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts-technical-overview.html
# https://docs.aws.amazon.com/eks/latest/userguide/create-service-account-iam-policy-and-role.html

data "aws_kms_alias" "ssm" {
  name = var.kms_alias_name
}

locals {
  eks_outputs                      = module.eks.outputs
  eks_cluster_identity_oidc_issuer = replace(local.eks_outputs.eks_cluster_identity_oidc_issuer, "https://", "")
  cluster_name                     = local.eks_outputs.eks_cluster_id

  account_id          = module.account_map.outputs.full_account_map[module.this.stage]
  identity_account_id = module.account_map.outputs.full_account_map.identity

  # Only service accounts in the service_account_list will be created
  service_account_list = concat(var.standard_service_accounts, var.optional_service_accounts)

  # Unfortunately, we cannot create a map piece by piece, so
  # every service account module has to register in this output_map
  output_map = {
    alb-controller       = module.alb-controller.outputs
    autoscaler           = module.autoscaler.outputs
    cert-manager         = module.cert-manager.outputs
    external-dns         = module.external-dns.outputs
    github-action-runner = module.github-action-runner.outputs
  }

  cluster_context = {
    aws_account_number          = local.account_id
    eks_cluster_oidc_issuer_url = local.eks_cluster_identity_oidc_issuer
    service_account_list        = local.service_account_list
  }
}
