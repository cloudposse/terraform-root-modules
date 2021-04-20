variable "region" {
  type        = string
  description = "AWS Region"
}

variable "datadog_aws_account_id" {
  type        = string
  description = "The AWS account ID Datadog's integration servers use for all integrations"
  default     = "464622532012"
}

variable "integrations" {
  type        = list(string)
  description = "List of AWS permission names to apply for different integrations (e.g. 'all', 'core')"
  default     = ["all"]
}

variable "filter_tags" {
  type        = list(string)
  description = "An array of EC2 tags (in the form `key:value`) that defines a filter that Datadog use when collecting metrics from EC2. Wildcards, such as ? (for single characters) and * (for multiple characters) can also be used"
  default     = null
}

variable "host_tags" {
  type        = list(string)
  description = "An array of tags (in the form `key:value`) to add to all hosts and metrics reporting through this integration"
  default     = []
}

variable "excluded_regions" {
  type        = list(string)
  description = "An array of AWS regions to exclude from metrics collection"
  default     = []
}

variable "account_specific_namespace_rules" {
  type        = map(string)
  description = "An object, (in the form {\"namespace1\":true/false, \"namespace2\":true/false} ), that enables or disables metric collection for specific AWS namespaces for this AWS account only"
  default     = {}
}

variable "secrets_store_type" {
  type        = string
  description = "Secret store type for Datadog API and app keys. Valid values: `SSM`, `ASM`"
  default     = "ASM"
}

variable "datadog_api_secret_key" {
  type        = string
  description = "The key of the Datadog API secret"
  default     = "datadog/datadog_api_key"
}

variable "datadog_app_secret_key" {
  type        = string
  description = "The key of the Datadog Application secret"
  default     = "datadog/datadog_app_key"
}
