variable "region" {
  type        = string
  description = "AWS Region"
}

variable "standard_service_accounts" {
  type        = list(string)
  description = "List of standard service accounts expected to be enabled everywhere"
}

variable "optional_service_accounts" {
  type        = list(string)
  default     = []
  description = "List of optional service accounts to enable"
}

// AWS KMS alias used for encryption/decryption of SSM parameters
// default is alias used in SSM
variable "kms_alias_name" {
  default = "alias/aws/ssm"
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

variable "dns_gbl_delegated_environment_name" {
  type        = string
  description = "The name of the environment where global `dns_delegated` is provisioned"
  default     = "gbl"
}

variable "iam_primary_roles_environment_name" {
  type        = string
  description = "The name of the environment where global `iam_primary_roles` is provisioned"
  default     = "gbl"
}

variable "iam_primary_roles_stage_name" {
  type        = string
  description = "The name of the stage where `iam_primary_roles` is provisioned"
  default     = "identity"
}
