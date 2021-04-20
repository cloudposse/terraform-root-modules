variable "region" {
  type        = string
  description = "AWS Region"
}

variable "alert_tags" {
  type        = list(string)
  description = "List of alert tags to add to all alert messages, e.g. `[\"@opsgenie\"]` or `[\"@devops\", \"@opsgenie\"]`"
  default     = null
}

variable "alert_tags_separator" {
  type        = string
  description = "Separator for the alert tags. All strings from the `alert_tags` variable will be joined into one string using the separator and then added to the alert message"
  default     = "\n"
}

variable "datadog_monitors_config_paths" {
  type        = list(string)
  description = "List of paths to Datadog monitor configurations"
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
