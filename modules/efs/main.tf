locals {
  eks_cluster_managed_security_group_id = data.terraform_remote_state.eks.outputs.eks_cluster_managed_security_group_id
  private_subnet_ids                    = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  vpc_id                                = data.terraform_remote_state.vpc.outputs.vpc_id
  zone_id                               = data.terraform_remote_state.dns_delegated.outputs.default_dns_zone_id
}

module "efs" {
  source = "git::https://github.com/cloudposse/terraform-aws-efs.git?ref=tags/0.30.1"

  region                          = var.region
  vpc_id                          = local.vpc_id
  subnets                         = local.private_subnet_ids
  security_groups                 = [local.eks_cluster_managed_security_group_id]
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode
  dns_name                        = var.dns_name
  zone_id                         = local.zone_id
  encrypted                       = true
  kms_key_id                      = module.kms_key_efs.key_arn

  context = module.this.context
}

module "kms_key_efs" {
  source = "git::https://github.com/cloudposse/terraform-aws-kms-key.git?ref=tags/0.10.0"

  description             = "KMS key for EFS"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key_efs.json

  context = module.this.context
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "kms_key_efs" {
  # https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default-allow-administrators
  # https://aws.amazon.com/premiumsupport/knowledge-center/update-key-policy-future/
  statement {
    sid    = "Enable the account that owns the KMS key to manage it via IAM"
    effect = "Allow"

    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]

    principals {
      type = "AWS"

      identifiers = [
        format("arn:aws:iam::%s:root", data.aws_caller_identity.current.account_id)
      ]
    }
  }

  # https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_aws-services-that-work-with-iam.html
  # https://docs.aws.amazon.com/efs/latest/ug/using-service-linked-roles.html
  statement {
    sid    = "Allow EFS to encrypt with the KMS key"
    effect = "Allow"

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]

    resources = [
      "*"
    ]

    principals {
      type = "Service"

      identifiers = [
        "elasticfilesystem.amazonaws.com"
      ]
    }
  }
}
