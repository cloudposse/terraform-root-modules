locals {
  eks_outputs = module.eks.outputs
  vpc_outputs = module.vpc.outputs

  eks_cluster_managed_security_group_id = local.eks_outputs.eks_cluster_managed_security_group_id

  vpc_id             = local.vpc_outputs.vpc_id
  private_subnet_ids = local.vpc_outputs.private_subnet_ids

  # A SINGLE_INSTANCE deployment requires one subnet. An ACTIVE_STANDBY_MULTI_AZ deployment requires two subnets
  subnet_ids = var.deployment_mode == "SINGLE_INSTANCE" ? slice(local.private_subnet_ids, 0, 1) : slice(local.private_subnet_ids, 0, 2)
}

module "mq_broker" {
  source  = "cloudposse/mq-broker/aws"
  version = "0.14.0"

  vpc_id                  = local.vpc_id
  subnet_ids              = local.subnet_ids
  allowed_security_groups = [local.eks_cluster_managed_security_group_id]

  apply_immediately            = var.apply_immediately
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  deployment_mode              = var.deployment_mode
  engine_type                  = var.engine_type
  engine_version               = var.engine_version
  host_instance_type           = var.host_instance_type
  publicly_accessible          = var.publicly_accessible
  general_log_enabled          = var.general_log_enabled
  audit_log_enabled            = var.audit_log_enabled
  use_existing_security_groups = var.use_existing_security_groups
  kms_ssm_key_arn              = var.kms_ssm_key_arn
  encryption_enabled           = var.encryption_enabled
  kms_mq_key_arn               = var.kms_mq_key_arn
  use_aws_owned_key            = var.use_aws_owned_key

  context = module.this.context
}
