locals {
  requester_vpc_id = module.requester_vpc.outputs.vpc_id
}

module "vpc_peering" {
  source  = "cloudposse/vpc-peering-multi-account/aws"
  version = "0.16.0"

  auto_accept = var.auto_accept

  requester_allow_remote_vpc_dns_resolution = var.requester_allow_remote_vpc_dns_resolution
  requester_aws_assume_role_arn             = module.iam_roles.terraform_role_arn
  requester_region                          = var.region
  requester_vpc_id                          = local.requester_vpc_id

  accepter_allow_remote_vpc_dns_resolution = var.accepter_allow_remote_vpc_dns_resolution
  accepter_aws_assume_role_arn             = var.accepter_aws_assume_role_arn
  accepter_region                          = var.accepter_region
  accepter_vpc_id                          = var.accepter_vpc_id

  context = module.this.context
}
