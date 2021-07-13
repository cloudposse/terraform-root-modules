locals {
  ses_domain  = module.dns_delegated.outputs.default_domain_name
  ses_zone_id = module.dns_delegated.outputs.default_dns_zone_id
}


data "aws_caller_identity" "current" {}

module "ses" {
  source  = "cloudposse/ses/aws"
  version = "0.14.1"

  domain        = local.ses_domain
  zone_id       = local.ses_zone_id
  verify_dkim   = var.ses_verify_dkim
  verify_domain = var.ses_verify_domain

  context = module.this.context
}

module "kms_key_ses" {
  source  = "cloudposse/kms-key/aws"
  version = "0.9.1"

  description             = "KMS key for SES"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key_ses.json

  context = module.this.context
}

resource "aws_ssm_parameter" "ses_access_key_id" {
  name        = "/ses/ses_access_key_id"
  value       = module.ses.access_key_id
  description = "SES user IAM access key ID for usage with SES API"
  type        = "String"
  overwrite   = true
}

resource "aws_ssm_parameter" "ses_secret_access_key" {
  name        = "/ses/ses_secret_access_key"
  value       = module.ses.secret_access_key
  description = "SES user IAM secret key for usage with SES API"
  type        = "SecureString"
  key_id      = module.kms_key_ses.key_arn
  overwrite   = true
}

resource "aws_ssm_parameter" "ses_user_name" {
  name        = "/ses/ses_user_name"
  value       = module.ses.user_name
  description = "SES IAM user name"
  type        = "String"
  overwrite   = true
}

resource "aws_ssm_parameter" "ses_smtp_password" {
  name        = "/ses/ses_smtp_password"
  value       = module.ses.ses_smtp_password
  description = "SES SMTP password"
  type        = "SecureString"
  key_id      = module.kms_key_ses.key_arn
  overwrite   = true
}


data "aws_iam_policy_document" "kms_key_ses" {
  # https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html#key-policy-default-allow-administrators
  # https://aws.amazon.com/premiumsupport/knowledge-center/update-key-policy-future/
  statement {
    sid    = "Allow the account identity to manage the KMS key"
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

  statement {
    sid    = "Allow SES to encrypt with the KMS key"
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:GenerateDataKey*"
    ]

    resources = [
      "*"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ses.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:EncryptionContext:aws:ses:source-account"

      values = [
        data.aws_caller_identity.current.account_id
      ]
    }
  }
}
