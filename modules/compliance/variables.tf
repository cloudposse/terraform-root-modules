variable "region" {
  type        = string
  description = "AWS Region"
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

variable "import_profile_name" {
  type        = string
  default     = null
  description = "AWS Profile to use when importing a resource"
}

variable "privileged" {
  type        = bool
  description = "True if the default provider already has access to the backend"
  default     = false
}

#-----------------------------------------------------------------------------------------------------------------------
# AWS CONFIG
#-----------------------------------------------------------------------------------------------------------------------
variable "global_environment_name" {
  type        = string
  description = "Global environment name"
  default     = "gbl"
}

variable "root_account_stage_name" {
  type        = string
  description = "The stage name for the root account"
  default     = "root"
}

variable "config_bucket_stage" {
  type        = string
  description = "The stage of the AWS Config S3 Bucket"
}

variable "config_bucket_env" {
  type        = string
  description = "The environment of the AWS Config S3 Bucket"
}

variable "cloudtrail_bucket_stage" {
  type        = string
  description = "The stage of the AWS Cloudtrail S3 Bucket"
}

variable "cloudtrail_bucket_env" {
  type        = string
  description = "The environment of the AWS Cloudtrail S3 Bucket"
}

variable "enabled_regions" {
  type        = set(string)
  description = "A list of enabled regions"
  default     = []
}

variable "config_rules_paths" {
  default = []
}

variable "central_resource_collector_account" {
  description = "The account ID of a central account that will aggregate AWS Config from other accounts"
  type        = string
  default     = null
}

variable "central_logging_account" {
  description = <<-DOC
    The name of the account that is the centralized logging account. The config rules associated with logging in the 
    catalog (loggingAccountOnly: true) will be installed only in this account.
  DOC
  type        = string
}
variable "child_resource_collector_accounts" {
  description = "The account IDs of other accounts that will send their AWS Configuration to this account"
  type        = set(string)
  default     = null
}

#-----------------------------------------------------------------------------------------------------------------------
# VARS FOR AWS SECURITYHUB
#-----------------------------------------------------------------------------------------------------------------------
variable "securityhub_central_account" {
  description = "The account name of a central account that will aggregate AWS SecurityHub data from other accounts"
  type        = string
  default     = null
}

variable "securityhub_enabled_standards" {
  description = "A list of standards to enable in the account"
  type        = set(string)
  default     = []
}

variable "securityhub_create_sns_topic" {
  description = "Flag to indicate whether an SNS topic should be created for notifications."
  type        = bool
  default     = false
}
