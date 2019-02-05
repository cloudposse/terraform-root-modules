module "kops_admin_access_group_staging" {
  source            = "git::https://github.com/cloudposse/terraform-aws-organization-access-group.git?ref=tags/0.3.0"
  enabled           = "${contains(var.kops_iam_accounts_enabled, "staging") == true ? "true" : "false"}"
  namespace         = "${var.namespace}"
  stage             = "staging"
  name              = "admin"
  attributes        = ["kops"]
  role_name         = "${var.kops_admin_role_name}"
  user_names        = []
  member_account_id = "${data.terraform_remote_state.accounts.staging_account_id}"
  require_mfa       = "true"
}

module "kops_readonly_access_group_staging" {
  source            = "git::https://github.com/cloudposse/terraform-aws-organization-access-group.git?ref=tags/0.3.0"
  enabled           = "${contains(var.kops_iam_accounts_enabled, "staging") == true ? "true" : "false"}"
  namespace         = "${var.namespace}"
  stage             = "staging"
  name              = "readonly"
  attributes        = ["kops"]
  role_name         = "${var.kops_readonly_role_name}"
  user_names        = []
  member_account_id = "${data.terraform_remote_state.accounts.staging_account_id}"
  require_mfa       = "true"
}
