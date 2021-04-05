locals {
  primary_role_map   = module.primary_roles.outputs.role_name_role_arn_map
  delegated_role_map = module.delegated_roles.outputs.role_name_role_arn_map
  eks_outputs        = module.eks.outputs
  vpc_outputs        = module.vpc.outputs

  attributes         = flatten(concat(module.this.attributes, [var.color]))
  public_subnet_ids  = local.vpc_outputs.public_subnet_ids
  private_subnet_ids = local.vpc_outputs.private_subnet_ids
  vpc_id             = local.vpc_outputs.vpc_id

  primary_iam_roles = [for role in var.primary_iam_roles : {
    rolearn  = local.primary_role_map[role.role]
    username = format("identity-%s", role.role)
    groups   = role.groups
  }]

  delegated_iam_roles = [for role in var.delegated_iam_roles : {
    rolearn  = local.delegated_role_map[role.role]
    username = format("%s-%s", module.this.stage, role.role)
    groups   = role.groups
  }]

  map_additional_iam_roles = concat(local.primary_iam_roles, local.delegated_iam_roles)
  managed_worker_role_arns = local.eks_outputs.eks_managed_node_workers_role_arns
  worker_role_arns = compact(concat([
    module.spotinst_role.outputs.workers_role_arn
  ], var.map_additional_worker_roles, local.managed_worker_role_arns))

  subnet_type_tag_key = var.subnet_type_tag_key != null ? var.subnet_type_tag_key : local.vpc_outputs.vpc.subnet_type_tag_key
}

module "eks_cluster" {
  source  = "cloudposse/eks-cluster/aws"
  version = "0.34.1"

  region     = var.region
  attributes = local.attributes

  allowed_security_groups      = var.allowed_security_groups
  allowed_cidr_blocks          = var.allowed_cidr_blocks
  apply_config_map_aws_auth    = var.apply_config_map_aws_auth
  cluster_log_retention_period = var.cluster_log_retention_period
  enabled_cluster_log_types    = var.enabled_cluster_log_types
  endpoint_private_access      = var.cluster_endpoint_private_access
  endpoint_public_access       = var.cluster_endpoint_public_access
  kubernetes_version           = var.cluster_kubernetes_version
  oidc_provider_enabled        = var.oidc_provider_enabled
  map_additional_aws_accounts  = var.map_additional_aws_accounts
  map_additional_iam_roles     = local.map_additional_iam_roles
  map_additional_iam_users     = var.map_additional_iam_users
  public_access_cidrs          = var.public_access_cidrs
  subnet_ids                   = concat(local.private_subnet_ids, local.public_subnet_ids)
  vpc_id                       = local.vpc_id

  kubernetes_config_map_ignore_role_changes = false

  # Managed Node Groups do not expose nor accept any Security Groups.
  # Instead, EKS creates a Security Group and applies it to ENI that is attached to EKS Control Plane master nodes and to any managed workloads.
  #workers_security_group_ids = compact([local.vpn_allowed_cidr_sg])

  # Ensure ordering of resource creation:
  # 1. Create the EKS cluster
  # 2. Create any resources OTHER THAN MANAGED NODE GROUPS that need to be added to the
  #    Kubernetes `aws-auth` configMap by our Terraform
  # 3. Use Terraform to create the Kubernetes `aws-auth` configMap we need
  # 4. Create managed node groups. AWS EKS will automatically add newly created
  #    managed node groups to the Kubernetes `aws-auth` configMap.
  #
  # We must execute steps in this order because:
  # - 1 before 3 because we cannot add a configMap to a cluster that does not exist
  # - 2 before 3 because Terraform will not create and update the configMap in separate steps, so it must have
  #   all the data to add before it creates the configMap
  # - 3 before 4 because EKS will create the Kubernetes `aws-auth` configMap if it does not exist
  #   when it creates the first managed node group, and Terraform will not modify a resource it did not create
  #
  # We count on the EKS cluster module to ensure steps 1-3 are done in the right order.
  # We then depend on the kubernetes_config_map_id, using the `module_depends_on` feature of the node-group module,
  # to ensure we do not proceed to step 4 until after step 3 is completed.

  # workers_role_arns is part of the data that needs to be collected/created in step 2 above
  # because it goes into the `aws-auth` configMap created in step 3. However, because of the
  # ordering requirements, we cannot wait for new managed node groups to be created. Fortunately,
  # this is not necessary, because AWS EKS will automatically add node groups to the `aws-auth` configMap
  # when they are created. However, after they are created, they will not be replaced if they are
  # later removed, and in step 3 we replace the entire configMap. So we have to add the pre-existing
  # managed node groups here, and we get that by reading our current (pre plan or apply) Terraform state.
  workers_role_arns = local.worker_role_arns

  context = module.this.context
}
