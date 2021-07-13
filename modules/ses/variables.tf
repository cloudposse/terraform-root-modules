variable "region" {
  type        = string
  description = "AWS Region"
}

variable "ses_verify_domain" {
  type        = bool
  description = "If provided the module will create Route53 DNS records used for domain verification."
  default     = null
}

variable "ses_verify_dkim" {
  type        = bool
  description = "If provided the module will create Route53 DNS records used for DKIM verification."
  default     = null
}
