locals {
  roles_config     = merge(var.primary_roles_config, var.delegated_roles_config)
  role_name_map    = { for role_name, config in local.roles_config : role_name => format("%s-%s", module.this.id, role_name) }
  configured_roles = keys(local.roles_config)

  # At some point we may be able to automate assume_role_restricted, so use a local
  assume_role_restricted    = var.assume_role_restricted
  assume_role_use_whitelist = !(local.assume_role_restricted && var.default_assume_role_enabled)

  custom_policy_map = {
    cicd                  = aws_iam_policy.cicd.arn
    delegated_assume_role = aws_iam_policy.delegated_assume_role.arn
  }

  # Intermediate step in calculating all policy attachments.
  # Create a list of [role, arn] lists
  # role_attachments_product_list = concat([ for role_name, config in local.roles_config : setproduct([role_name], [for arn in config.role_policy_arns : arn]) ]...)
  # Also work around https://github.com/hashicorp/terraform/issues/22404
  # Create a list of strings that combine role name with policy arn to attach to the role
  role_attachments_product_list = flatten([for role_name, config in local.roles_config : [for arn in config.role_policy_arns : "${role_name}+${arn}"]])
  role_attachments = { for role_arns in local.role_attachments_product_list : (
    # Make the first key just the role name, to keep the keys short when possible
    local.roles_config[split("+", role_arns)[0]].role_policy_arns[0] == split("+", role_arns)[1] ? split("+", role_arns)[0] : role_arns) =>
    # The value is the policy ARN to attach to the role
    try(local.custom_policy_map[split("+", role_arns)[1]], split("+", role_arns)[1])
  }

  # The roles_config allows identity-x to assume corp-x, but we cannot allow identity-x to assume identity-x
  # because to do that we would need the ARN of identity-x before it is created.
  allowed_assume_role_principals_map = {
    for target_role, config in local.roles_config : target_role => [
      for source_role in config.trusted_primary_roles : # aws_iam_role.default[role].arn
      format("arn:aws:iam::%s:role/%s", var.primary_account_id, local.role_name_map[source_role]) if !contains([target_role, "cicd"], source_role)
    ]
  }
  denied_assume_role_principals_map = {
    for target_role in local.configured_roles : target_role => [
      for source_role in local.configured_roles :
      format("arn:aws:iam::%s:role/%s", var.primary_account_id, local.role_name_map[source_role]) if !contains(concat([target_role], local.roles_config[target_role].trusted_primary_roles), source_role)
    ]
  }
}

data "aws_iam_policy_document" "empty" {
}

data "aws_iam_policy_document" "saml_provider_assume" {
  statement {
    sid = "SamlProviderAssume"
    actions = [
      "sts:AssumeRoleWithSAML",
      "sts:TagSession",
    ]

    principals {
      type = "Federated"

      # Loop over the IDPs from the `sso` component
      identifiers = [for name, arn in module.sso.outputs.saml_provider_arns : arn]
    }

    condition {
      test     = "StringEquals"
      variable = "SAML:aud"
      values   = ["https://signin.aws.amazon.com/saml"]
    }
  }
}

data "aws_iam_policy_document" "primary_roles_assume_whitelist" {
  for_each = local.assume_role_use_whitelist ? local.roles_config : {}

  dynamic "statement" {
    for_each = length(local.allowed_assume_role_principals_map[each.key]) > 0 ? ["has_principals"] : []
    content {
      sid = "IdentityAccountAssume"
      actions = [
        "sts:AssumeRole",
        "sts:TagSession",
      ]

      principals {
        type = "AWS"

        identifiers = local.assume_role_restricted ? local.allowed_assume_role_principals_map[each.key] : [
          format("arn:aws:iam::%s:root", var.primary_account_id)
        ]
      }
    }
  }

  # Provide a list of roles that are allowed to assume cicd roles.
  dynamic "statement" {
    for_each = local.assume_role_restricted && each.key == "cicd" ? var.cicd_sa_roles : []
    content {
      sid = "CicdIdentityAssumeRole"
      actions = [
        "sts:AssumeRole",
        "sts:TagSession",
      ]

      principals {
        type        = "AWS"
        identifiers = [statement.value]
      }
    }
  }

  # Allow designated Spacelift roles to assume the Identity Ops role.
  dynamic "statement" {
    for_each = local.assume_role_restricted && each.key == "ops" ? ["spacelift"] : []
    content {
      sid = "SpaceliftOpsIdentityAssumeRole"
      actions = [
        "sts:AssumeRole",
        "sts:TagSession",
      ]

      principals {
        type        = "AWS"
        identifiers = var.spacelift_roles
      }
    }
  }
}

data "aws_iam_policy_document" "primary_roles_assume_blacklist" {
  for_each = !local.assume_role_use_whitelist ? local.roles_config : {}

  statement {
    sid    = "IdentityAccountDefaultAssume"
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]
    principals {
      type = "AWS"

      identifiers = [format("arn:aws:iam::%s:root", var.primary_account_id)]
    }
  }

  dynamic "statement" {
    for_each = length(local.denied_assume_role_principals_map[each.key]) > 0 ? ["has_principals"] : []
    content {
      sid    = "IdentityAccountDeny"
      effect = "Deny"
      actions = [
        "sts:AssumeRole",
        "sts:TagSession",
      ]

      principals {
        type = "AWS"

        identifiers = local.denied_assume_role_principals_map[each.key]
      }
    }
  }

  # Provide a list of roles that are allowed to assume cicd roles.
  dynamic "statement" {
    for_each = local.assume_role_restricted && each.key == "cicd" ? var.cicd_sa_roles : []
    content {
      sid    = "CicdIdentityAssumeRole"
      effect = "Allow"
      actions = [
        "sts:AssumeRole",
        "sts:TagSession",
      ]

      principals {
        type        = "AWS"
        identifiers = [statement.value]
      }
    }
  }

  # Allow designated Spacelift roles to assume the Identity Ops role.
  dynamic "statement" {
    for_each = local.assume_role_restricted && each.key == "ops" ? ["spacelift"] : []
    content {
      sid = "SpaceliftOpsIdentityAssumeRole"
      actions = [
        "sts:AssumeRole",
        "sts:TagSession",
      ]

      principals {
        type = "AWS"

        identifiers = var.spacelift_roles
      }
    }
  }
}

data "aws_iam_policy_document" "aggregated" {
  for_each = local.roles_config

  source_json   = local.roles_config[each.key].sso_login_enabled ? data.aws_iam_policy_document.saml_provider_assume.json : data.aws_iam_policy_document.empty.json
  override_json = local.assume_role_use_whitelist ? data.aws_iam_policy_document.primary_roles_assume_whitelist[each.key].json : data.aws_iam_policy_document.primary_roles_assume_blacklist[each.key].json
}

resource "aws_iam_role" "default" {
  for_each = local.roles_config

  name                 = local.role_name_map[each.key]
  description          = local.roles_config[each.key]["role_description"]
  assume_role_policy   = data.aws_iam_policy_document.aggregated[each.key].json
  max_session_duration = var.iam_role_max_session_duration
  tags                 = merge(module.this.tags, map("Name", local.role_name_map[each.key]))
}

resource "aws_iam_role_policy_attachment" "default" {
  for_each = local.role_attachments

  role       = aws_iam_role.default[split("+", each.key)[0]].name
  policy_arn = each.value
}
