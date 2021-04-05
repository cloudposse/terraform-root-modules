# This file is included by default in terraform plans

enabled = true

name = "eks"

allowed_security_groups = []

allowed_cidr_blocks = []

cluster_log_retention_period = 90

cluster_endpoint_private_access = true

cluster_endpoint_public_access = true

cluster_kubernetes_version = "1.18"

enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

oidc_provider_enabled = true


# EKS IAM Authentication settings
# By default, you can authenticate to EKS cluster only by assuming the role that created the cluster.
# In order to apply the Auth Config Map to allow other roles to login to the cluster,
# `kubectl` will need to assume the same role that created the cluster - that's why we are setting
# aws_cli_assume_role_arn in each stage to the `terraform` role.
# After the Auth Config Map is applied, the other IAM roles in
# `primary_additional_iam_roles` and `map_additional_iam_roles` will be able to authenticate.
apply_config_map_aws_auth = true

# Roles from the primary account to allow access to the cluster
primary_iam_roles = [
  {
    role   = "admin"
    groups = ["system:masters", "idp:ops"]
  },
  {
    role   = "ops"
    groups = ["idp:ops"]
  },
  {
    role   = "poweruser"
    groups = ["idp:poweruser"]
  },
  {
    role   = "observer"
    groups = ["idp:observer"]
  }
]

# Roles from the account owning the cluster to allow access to the cluster
delegated_iam_roles = [
  {
    role   = "admin"
    groups = ["system:masters", "idp:ops"]
  },
  {
    role   = "ops"
    groups = ["idp:ops"]
  },
  {
    role   = "poweruser"
    groups = ["idp:poweruser"]
  },
  {
    role   = "observer"
    groups = ["idp:observer"]
  },
  {
    role   = "terraform"
    groups = ["system:masters"]
  },
  {
    role   = "helm"
    groups = ["system:masters"]
  }
]

public_access_cidrs = ["0.0.0.0/0"]

node_group_defaults = {
  availability_zones = null # use default region_availability_zones

  desired_group_size = 3 # number of instances to start with, must be >= number of AZs
  max_group_size     = 6
  min_group_size     = 3

  # Can only set one of ami_release_version or kubernetes_version
  # Leave both null to use latest AMI for Cluster Kubernetes version
  kubernetes_version  = null # use cluster_kubernetes_version
  ami_release_version = null # use latest for given Kubernetes version

  attributes                = []
  create_before_destroy     = true
  disk_size                 = 100 # root EBS volume size in GB
  enable_cluster_autoscaler = true
  instance_types            = ["t3.medium"]
  ami_type                  = "AL2_x86_64"
  kubernetes_labels         = {}
  kubernetes_taints         = {}
  resources_to_tag          = ["instance", "volume"]
  tags                      = null
}
