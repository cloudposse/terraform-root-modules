variable "region" {
  type        = string
  description = "AWS Region"
}

variable "global_environment_name" {
  type        = string
  description = "Global environment name"
  default     = "gbl"
}
variable "root_account_stage_name" {
  type        = string
  description = "The name of the stage where `account_map` is provisioned"
  default     = "root"
}

variable "privileged" {
  type        = bool
  description = "True if the default provider already has access to the backend"
  default     = false
}

variable "account_assignments" {
  type = map(map(map(object({
    permission_sets = list(string)
    }
  ))))
  default = {}
}
