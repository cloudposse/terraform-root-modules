
// Spotinst configuration
variable "spotinst_token_ssm_key" {
  type        = string
  description = "SSM key for Spot Personal Access token"
  default     = "/spotinst/spotinst_token"
}

variable "spotinst_account_ssm_key" {
  type        = string
  description = "SSM key for Spot account ID"
  default     = "/spotinst/spotinst_account"
}

variable "spotinst_instance_profile_pattern" {
  type        = string
  description = <<-EOT
    Pattern for the name of the AWS Instance Profile to use for Spotinst Worker instances:
    `format(spotinst_instance_profile_pattern, var.namespace, var.environment, var.stage)`
    If empty or null, a new instance profile will be created.
    EOT
  default     = "%v-gbl-%[3]v-spotinst-worker"
}

variable "spotinst_oceans" {
  type = map(object({
    # Additional attributes (e.g. `1`) for the ocean
    attributes         = list(string)
    desired_group_size = number
    # Disk size in GiB for worker nodes. Terraform will only perform drift detection if a configuration value is provided.
    disk_size = number
    # List of allowed instance types. Leave null to allow Spot to choose any type.
    instance_types = list(string)
    # Type of Amazon Machine Image (AMI) associated with the EKS Node Group
    ami_type = string
    # EKS AMI version to use, e.g. "1.16.13-20200821" (no "v").
    ami_release_version = string
    # Desired Kubernetes master version. If you do not specify a value, the cluster version is used
    kubernetes_version = string # set to null to use cluster_kubernetes_version
    max_group_size     = number
    min_group_size     = number
    tags               = map(string)
  }))
  description = "List of objects defining a Spotinst Ocean for the cluster"
  default     = {}
}

variable "spotinst_ocean_defaults" {
  # Any value in the node group that is null will be replaced
  # by the value in this object, which can also be null
  type = object({
    attributes          = list(string)
    desired_group_size  = number
    disk_size           = number
    instance_types      = list(string)
    ami_type            = string
    ami_release_version = string
    kubernetes_version  = string # set to null to use cluster_kubernetes_version
    max_group_size      = number
    min_group_size      = number
    tags                = map(string)
  })
  description = "Defaults for node groups in the cluster"
  default = {
    attributes          = []
    desired_group_size  = 1
    disk_size           = 20
    instance_types      = null
    ami_type            = "AL2_x86_64"
    ami_release_version = null
    kubernetes_version  = null # set to null to use cluster_kubernetes_version
    max_group_size      = 100
    min_group_size      = null
    tags                = {}
  }
}

output "eks_spotinst_ocean_controller_ids" {
  description = "The ID of the Ocean controller"
  value       = toset(values(module.spotinst_oceans)[*].ocean_controller_id)
}
