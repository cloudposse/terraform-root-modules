variable "iam_role_max_session_duration" {
  type        = number
  default     = 43200
  description = "The maximum session duration (in seconds) that you want to set for the IAM roles. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "primary_account_id" {
  description = "Primary authentication account id used as the source for assume role"
  type        = string
}

variable "default_account_role_policy_arns" {
  description = "Custom IAM policy ARNs to override defaults"
  type        = map(list(string))
}

variable "account_role_policy_arns" {
  description = "Custom IAM policy ARNs to override defaults"
  default     = {}
  type        = map(list(string))
}

variable "trusted_primary_role_overrides" {
  description = "Override default list of primary roles that can assume this one"
  default     = {}
  type        = map(list(string))
}

variable "exclude_roles" {
  description = "Roles in roles_config that should NOT be created"
  default     = []
  type        = list(string)
}

variable "allow_same_account_assume_role" {
  type        = bool
  default     = false
  description = "Set true to allow roles to assume other roles in the same account"
}

variable "account_map_environment_name" {
  type        = string
  description = "The name of the environment where `account_map` is provisioned"
  default     = "gbl"
}

variable "account_map_stage_name" {
  type        = string
  description = "The name of the stage where `account_map` is provisioned"
  default     = "root"
}


variable "iam_roles_environment_name" {
  type        = string
  description = "The name of the environment where the IAM roles are provisioned"
  default     = "gbl"
}

variable "iam_primary_roles_stage_name" {
  type        = string
  description = "The name of the stage where the IAM primary roles are provisioned"
  default     = "identity"
}

variable "tfstate_backend_environment_name" {
  type        = string
  description = "The name of the stage where the Terraform state backend is provisioned"
  default     = "gbl"
}

variable "tfstate_backend_stage_name" {
  type        = string
  description = "The name of the stage where the Terraform state backend is provisioned"
  default     = "root"
}
