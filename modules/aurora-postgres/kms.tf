module "kms_key_rds" {
  source  = "cloudposse/kms-key/aws"
  version = "0.9.0"

  description             = "KMS key for Aurora Postgres"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = join("", data.aws_iam_policy_document.kms_key_rds.*.json)

  context = module.cluster.context
}

data "aws_caller_identity" "current" {
  count = local.enabled ? 1 : 0
}

# https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default-allow-administrators
# https://aws.amazon.com/premiumsupport/knowledge-center/update-key-policy-future/
data "aws_iam_policy_document" "kms_key_rds" {
  count = local.enabled ? 1 : 0

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
        format("arn:aws:iam::%s:root", join("", data.aws_caller_identity.current.*.account_id))
      ]
    }
  }

  # https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_aws-services-that-work-with-iam.html
  # https://docs.aws.amazon.com/efs/latest/ug/using-service-linked-roles.html
  statement {
    sid    = "Allow RDS to encrypt and decrypt with the KMS key"
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
        "rds.amazonaws.com"
      ]
    }
  }
}
