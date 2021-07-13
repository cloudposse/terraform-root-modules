variable "region" {
  type        = string
  description = "AWS Region"
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

variable "privileged" {
  type        = bool
  description = "True if the default provider already has access to the backend"
  default     = false
}

variable "create_iam_role" {
  description = "Flag to indicate whether an IAM Role should be created to grant the proper permissions for AWS Config"
  type        = bool
  default     = false
}

variable "iam_role_arn" {
  description = <<-DOC
    The ARN for an IAM Role AWS Config uses to make read or write requests to the delivery channel and to describe the 
    AWS resources associated with the account. This is only used if create_iam_role is false.
  
    If you want to use an existing IAM Role, set the value of this to the ARN of the existing topic and set 
    create_iam_role to false.
    
    See the AWS Docs for further information: 
    http://docs.aws.amazon.com/config/latest/developerguide/iamrole-permissions.html
  DOC
  default     = null
  type        = string
}

variable "securityhub_central_account" {
  description = "The account name of the AWS Account that houses the central Security Hub implementation."
  type        = string
}

variable "securityhub_member_accounts" {
  description = "A map of AWS Accounts to add as members to this account's SecurityHub configuration."
  type        = map(any)
  default     = {}
}

variable "securityhub_enabled_standards" {
  description = "A list of standards to enable in the account."
  type        = set(string)
  default     = []
}

variable "securityhub_create_sns_topic" {
  description = "Flag to indicate whether an SNS topic should be created for notifications."
  type        = bool
  default     = false
}

variable "config_rules_paths" {
  default = []
}

variable "global_resource_collector_region" {
  description = "The region that collects AWS Config data for global resources such as IAM"
  type        = string
}

variable "central_resource_collector_account" {
  description = "The account ID of a central account that will aggregate AWS Config from other accounts"
  type        = string
  default     = null
}

variable "child_resource_collector_accounts" {
  description = "The account IDs of other accounts that will send their AWS Configuration to this account"
  type        = set(string)
  default     = null
}

variable "is_logging_account" {
  description = <<-DOC
    Flag to indicate if this instance of AWS Config is being installed into a centralized logging account. If this flag
    is set to true, then the config rules associated with logging in the catalog (loggingAccountOnly: true) will be
    installed. If false, they will not be installed.
  DOC
  type        = bool
  default     = false
}
