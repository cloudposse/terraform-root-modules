variable "region" {
  type        = string
  description = "AWS Region"
}

variable "role_map" {
  type        = map(list(string))
  description = "Map of account:[role, role...]. Use `*` as role for entire account"
}

variable "iam_role_arn_template" {
  type        = string
  default     = "arn:aws:iam::%s:role/%s-%s-%s-%s"
  description = "IAM Role ARN template"
}

variable "privileged" {
  type        = bool
  description = "True if the default provider already has access to the backend"
  default     = false
}

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
