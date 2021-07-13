variable "organization_management_arn" {
  type        = string
  description = "The ARN of the role you want to assume for applying these changes - must be a root account for setting up Firewall Manager Admin Account."
  default     = null
}

variable "firewall_manager_administrator_arn" {
  type        = string
  description = "The ARN of the role you want to assume for destroying these changes - must be the AWS Firewall Manager administrator account. (contains admin_account_ids) "
  default     = null
}

variable "admin_account_id" {
  type        = string
  description = "An AWS account ID to associate with AWS Firewall Manager as the AWS Firewall Manager administrator account. This can be an AWS Organizations master account or a member account. Defaults to the current account."
}

variable "is_destroy" {
  type        = bool
  description = "Which command are we running through terraform"
  default     = false
}

variable "security_groups_common_policies" {
  type        = list(any)
  default     = []
  description = <<-DOC
    name:
      The friendly name of the AWS Firewall Manager Policy.
    delete_all_policy_resources:
      Whether to perform a clean-up process.
      Defaults to `true`.
    exclude_resource_tags:
      A boolean value, if `true` the tags that are specified in the `resource_tags` are not protected by this policy.
      If set to `false` and `resource_tags` are populated, resources that contain tags will be protected by this policy.
      Defaults to `false`.
    remediation_enabled:
      A boolean value, indicates if the policy should automatically applied to resources that already exist in the account.
      Defaults to `false`.
    resource_type_list:
      A list of resource types to protect. Conflicts with `resource_type`.
    resource_type:
      A resource type to protect. Conflicts with `resource_type_list`.
    resource_tags:
      A map of resource tags, that if present will filter protections on resources based on the `exclude_resource_tags`.
    exclude_account_ids:
      A list of AWS Organization member Accounts that you want to exclude from this AWS FMS Policy.
    include_account_ids:
      A list of AWS Organization member Accounts that you want to include for this AWS FMS Policy.
    policy_data:
      revert_manual_security_group_changes:
        Whether to revert manual Security Group changes.
        Defaults to `false`.
      exclusive_resource_security_group_management:
        Wheter to exclusive resource Security Group management.
        Defaults to `false`.
      apply_to_all_ec2_instance_enis:
        Whether to apply to all EC2 instance ENIs.
        Defaults to `false`.
      security_groups:
        A list of Security Group IDs.
  DOC
}

variable "security_groups_content_audit_policies" {
  type        = list(any)
  default     = []
  description = <<-DOC
    name:
      The friendly name of the AWS Firewall Manager Policy.
    delete_all_policy_resources:
      Whether to perform a clean-up process.
      Defaults to `true`.
    exclude_resource_tags:
      A boolean value, if `true` the tags that are specified in the `resource_tags` are not protected by this policy.
      If set to `false` and `resource_tags` are populated, resources that contain tags will be protected by this policy.
      Defaults to `false`.
    remediation_enabled:
      A boolean value, indicates if the policy should automatically applied to resources that already exist in the account.
      Defaults to `false`.
    resource_type_list:
      A list of resource types to protect. Conflicts with `resource_type`.
    resource_type:
      A resource type to protect. Conflicts with `resource_type_list`.
    resource_tags:
      A map of resource tags, that if present will filter protections on resources based on the `exclude_resource_tags`.
    exclude_account_ids:
      A list of AWS Organization member Accounts that you want to exclude from this AWS FMS Policy.
    include_account_ids:
      A list of AWS Organization member Accounts that you want to include for this AWS FMS Policy.
    policy_data:
      security_group_action:
        For `ALLOW`, all in-scope security group rules must be within the allowed range of the policy's security group rules.
        For `DENY`, all in-scope security group rules must not contain a value or a range that matches a rule value or range in the policy security group.
        Possible values: `ALLOW`, `DENY`.
      security_groups:
        A list of Security Group IDs.
  DOC
}

variable "security_groups_usage_audit_policies" {
  type        = list(any)
  description = <<-DOC
    name:
      The friendly name of the AWS Firewall Manager Policy.
    delete_all_policy_resources:
      Whether to perform a clean-up process.
      Defaults to `true`.
    exclude_resource_tags:
      A boolean value, if `true` the tags that are specified in the `resource_tags` are not protected by this policy.
      If set to `false` and `resource_tags` are populated, resources that contain tags will be protected by this policy.
      Defaults to `false`.
    remediation_enabled:
      A boolean value, indicates if the policy should automatically applied to resources that already exist in the account.
      Defaults to `false`.
    resource_type_list:
      A list of resource types to protect. Conflicts with `resource_type`.
    resource_type:
      A resource type to protect. Conflicts with `resource_type_list`.
    resource_tags:
      A map of resource tags, that if present will filter protections on resources based on the `exclude_resource_tags`.
    exclude_account_ids:
      A list of AWS Organization member Accounts that you want to exclude from this AWS FMS Policy.
    include_account_ids:
      A list of AWS Organization member Accounts that you want to include for this AWS FMS Policy.
    policy_data:
      delete_unused_security_groups:
        Whether to delete unused Security Groups.
        Defaults to `false`.
      coalesce_redundant_security_groups:
        Whether to coalesce redundant Security Groups.
        Defaults to `false`.

  DOC
}

variable "shiled_advanced_policies" {
  type        = list(any)
  default     = []
  description = <<-DOC
    name:
      The friendly name of the AWS Firewall Manager Policy.
    delete_all_policy_resources:
      Whether to perform a clean-up process.
      Defaults to `true`.
    exclude_resource_tags:
      A boolean value, if `true` the tags that are specified in the `resource_tags` are not protected by this policy.
      If set to `false` and `resource_tags` are populated, resources that contain tags will be protected by this policy.
      Defaults to `false`.
    remediation_enabled:
      A boolean value, indicates if the policy should automatically applied to resources that already exist in the account.
      Defaults to `false`.
    resource_type_list:
      A list of resource types to protect. Conflicts with `resource_type`.
    resource_type:
      A resource type to protect. Conflicts with `resource_type_list`.
    resource_tags:
      A map of resource tags, that if present will filter protections on resources based on the `exclude_resource_tags`.
    exclude_account_ids:
      A list of AWS Organization member Accounts that you want to exclude from this AWS FMS Policy.
    include_account_ids:
      A list of AWS Organization member Accounts that you want to include for this AWS FMS Policy.
  DOC
}

variable "waf_policies" {
  type        = list(any)
  default     = []
  description = <<-DOC
    name:
      The friendly name of the AWS Firewall Manager Policy.
    delete_all_policy_resources:
      Whether to perform a clean-up process.
      Defaults to `true`.
    exclude_resource_tags:
      A boolean value, if `true` the tags that are specified in the `resource_tags` are not protected by this policy.
      If set to `false` and `resource_tags` are populated, resources that contain tags will be protected by this policy.
      Defaults to `false`.
    remediation_enabled:
      A boolean value, indicates if the policy should automatically applied to resources that already exist in the account.
      Defaults to `false`.
    resource_type_list:
      A list of resource types to protect. Conflicts with `resource_type`.
    resource_type:
      A resource type to protect. Conflicts with `resource_type_list`.
    resource_tags:
      A map of resource tags, that if present will filter protections on resources based on the `exclude_resource_tags`.
    exclude_account_ids:
      A list of AWS Organization member Accounts that you want to exclude from this AWS FMS Policy.
    include_account_ids:
      A list of AWS Organization member Accounts that you want to include for this AWS FMS Policy.
  DOC
}

variable "waf_v2_policies" {
  type        = list(any)
  default     = []
  description = <<-DOC
    name:
      The friendly name of the AWS Firewall Manager Policy.
    delete_all_policy_resources:
      Whether to perform a clean-up process.
      Defaults to `true`.
    exclude_resource_tags:
      A boolean value, if `true` the tags that are specified in the `resource_tags` are not protected by this policy.
      If set to `false` and `resource_tags` are populated, resources that contain tags will be protected by this policy.
      Defaults to `false`.
    remediation_enabled:
      A boolean value, indicates if the policy should automatically applied to resources that already exist in the account.
      Defaults to `false`.
    resource_type_list:
      A list of resource types to protect. Conflicts with `resource_type`.
    resource_type:
      A resource type to protect. Conflicts with `resource_type_list`.
    resource_tags:
      A map of resource tags, that if present will filter protections on resources based on the `exclude_resource_tags`.
    exclude_account_ids:
      A list of AWS Organization member Accounts that you want to exclude from this AWS FMS Policy.
    include_account_ids:
      A list of AWS Organization member Accounts that you want to include for this AWS FMS Policy.
  DOC
}

variable "dns_firewall_policies" {
  type        = list(any)
  default     = []
  description = <<-DOC
    name:
      The friendly name of the AWS Firewall Manager Policy.
    delete_all_policy_resources:
      Whether to perform a clean-up process.
      Defaults to `true`.
    exclude_resource_tags:
      A boolean value, if `true` the tags that are specified in the `resource_tags` are not protected by this policy.
      If set to `false` and `resource_tags` are populated, resources that contain tags will be protected by this policy.
      Defaults to `false`.
    remediation_enabled:
      A boolean value, indicates if the policy should automatically applied to resources that already exist in the account.
      Defaults to `false`.
    resource_type_list:
      A list of resource types to protect. Conflicts with `resource_type`.
    resource_type:
      A resource type to protect. Conflicts with `resource_type_list`.
    resource_tags:
      A map of resource tags, that if present will filter protections on resources based on the `exclude_resource_tags`.
    exclude_account_ids:
      A list of AWS Organization member Accounts that you want to exclude from this AWS FMS Policy.
    include_account_ids:
      A list of AWS Organization member Accounts that you want to include for this AWS FMS Policy.
  DOC
}

variable "network_firewall_policies" {
  type        = list(any)
  default     = []
  description = <<-DOC
    name:
      The friendly name of the AWS Firewall Manager Policy.
    delete_all_policy_resources:
      Whether to perform a clean-up process.
      Defaults to `true`.
    exclude_resource_tags:
      A boolean value, if `true` the tags that are specified in the `resource_tags` are not protected by this policy.
      If set to `false` and `resource_tags` are populated, resources that contain tags will be protected by this policy.
      Defaults to `false`.
    remediation_enabled:
      A boolean value, indicates if the policy should automatically applied to resources that already exist in the account.
      Defaults to `false`.
    resource_type_list:
      A list of resource types to protect. Conflicts with `resource_type`.
    resource_type:
      A resource type to protect. Conflicts with `resource_type_list`.
    resource_tags:
      A map of resource tags, that if present will filter protections on resources based on the `exclude_resource_tags`.
    exclude_account_ids:
      A list of AWS Organization member Accounts that you want to exclude from this AWS FMS Policy.
    include_account_ids:
      A list of AWS Organization member Accounts that you want to include for this AWS FMS Policy.
  DOC
}
