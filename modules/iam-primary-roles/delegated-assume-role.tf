locals {
  root_account_id     = module.account_map.outputs.full_account_map[var.root_account_stage_name]
  identity_account_id = module.account_map.outputs.full_account_map[var.identity_account_stage_name]
  audit_account_id    = module.account_map.outputs.full_account_map[var.audit_account_stage_name]
}

data "aws_iam_policy_document" "delegated_assume_role" {
  statement {
    sid     = "DelegatedAssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    resources = [
      "arn:aws:iam::*:role/*",
    ]
  }

  statement {
    sid     = "DenyIdentityRootAssumeRole"
    effect  = "Deny"
    actions = ["sts:AssumeRole"]
    resources = [
      format("arn:aws:iam::%s:role/*", local.root_account_id),
      format("arn:aws:iam::%s:role/*", local.identity_account_id),
      format("arn:aws:iam::%s:role/*", local.audit_account_id),
    ]
  }
}

resource "aws_iam_policy" "delegated_assume_role" {
  name        = format("%s-delegatedAssumeRole", module.this.id)
  description = "Allow assume-role to delegated accounts"
  policy      = data.aws_iam_policy_document.delegated_assume_role.json
}
