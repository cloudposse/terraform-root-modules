variable "region" {
  type        = string
  description = "AWS Region"
}

variable "ssm_region" {
  type        = string
  description = "AWS Region housing SSM parameters"
}

variable "ssm_account" {
  type        = string
  description = "Account (stage) housing SSM parameters"
}

# AWS KMS alias used for encryption/decryption
# default is alias used in SSM
variable "kms_alias_name" {
  default = "alias/aws/ssm"
}

variable "install_gateway" {
  type        = bool
  default     = false
  description = "Set `true` to install a pair of gateways"
}

variable "install_relay" {
  type        = bool
  default     = true
  description = "Set `true` to install a pair of relays"
}

variable "create_roles" {
  type        = bool
  default     = false
  description = "Set `true` to create roles (should only be set in one account)"
}

variable "register_nodes" {
  type        = bool
  default     = true
  description = "Set `true` to register nodes as SSH targets"
}

## helm-release

variable "kubernetes_namespace" {
  type        = string
  description = "The Kubernetes namespace to install the release into. Defaults to `default`."
  default     = null
}

variable "dns_zone" {
  type        = string
  description = ""
  default     = null
}
