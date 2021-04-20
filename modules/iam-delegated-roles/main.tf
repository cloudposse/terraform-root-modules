locals {
  account_number          = module.account_map.outputs.full_account_map[module.this.stage]
  merged_role_policy_arns = merge(var.default_account_role_policy_arns, var.account_role_policy_arns)
  roles_config            = { for key, value in module.primary_roles.outputs.delegated_roles_config : key => value if !contains(var.exclude_roles, key) }
  roles_policy_arns       = { for key, value in local.roles_config : key => lookup(local.merged_role_policy_arns, key, value["role_policy_arns"]) }
  role_name_map           = { for role_name, config in module.primary_roles.outputs.delegated_roles_config : role_name => format("%s-%s", module.label.id, role_name) }

  trusted_primary_roles = { for key, value in local.roles_config : key => lookup(var.trusted_primary_role_overrides, key, value.trusted_primary_roles) }

  custom_policy_map = { "root-terraform" = try(aws_iam_policy.tfstate[0].arn, null) }

  # Intermediate step in calculating all policy attachments.
  # Create a list of [role, arn] lists
  # role_attachments_product_list = concat([ for role_name, config in var.roles_config : setproduct([role_name], [for arn in config.role_policy_arns : arn]) ]...)
  # Also work around https://github.com/hashicorp/terraform/issues/22404
  # Create a list of strings that combine role name with policy ARN to attach to the role
  role_attachments_product_list = flatten([for role_name, arns in local.roles_policy_arns : [for arn in arns : "${role_name}+${arn}"]])
  role_attachments = { for role_arns in local.role_attachments_product_list : (
    # Make the first key just the role name, to keep the keys short when possible
    local.roles_policy_arns[split("+", role_arns)[0]][0] == split("+", role_arns)[1] ? split("+", role_arns)[0] : role_arns) =>
    # The value is the policy ARN to attach to the role
    try(local.custom_policy_map[split("+", role_arns)[1]], split("+", role_arns)[1])
  }
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.24.1" # requires Terraform >= 0.13.0

  name = ""

  context = module.this.context
}

data "aws_iam_policy_document" "assume_role" {
  for_each = local.roles_config
  statement {
    sid = "IdentityAccountAssume"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]

    principals {
      type = "AWS"

      identifiers = concat([
        # Allow role in primary account to assume this role
        for role in local.trusted_primary_roles[each.key] : module.primary_roles.outputs.role_name_role_arn_map[role]
        ],
        var.allow_same_account_assume_role ? [
          for role in local.trusted_primary_roles[each.key] :
          format("arn:aws:iam::%s:role/%s", local.account_number, local.role_name_map[role]) if !contains(var.exclude_roles, role)
      ] : [])
    }
  }
}

resource "aws_iam_role" "default" {
  for_each = local.roles_config

  name                 = local.role_name_map[each.key]
  description          = each.value["role_description"]
  assume_role_policy   = data.aws_iam_policy_document.assume_role[each.key].json
  max_session_duration = var.iam_role_max_session_duration
  tags                 = merge(module.label.tags, map("Name", local.role_name_map[each.key]))
}

resource "aws_iam_role_policy_attachment" "default" {
  for_each = local.role_attachments

  role       = aws_iam_role.default[split("+", each.key)[0]].name
  policy_arn = each.value
}
