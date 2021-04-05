
locals {
  node_group_default_availability_zones = var.node_group_defaults.availability_zones == null ? var.region_availability_zones : var.node_group_defaults.availability_zones
  node_group_default_kubernetes_version = var.node_group_defaults.kubernetes_version == null ? var.cluster_kubernetes_version : var.node_group_defaults.kubernetes_version

  # values(module.region_node_group) is an array of `region_node_group` objects
  # values(module.region_node_group)[*].region_node_groups is an array of
  #   maps with keys availability zones and values the output map of terraform-aws-eks-node-group
  # node_groups is a flattened array of output maps of terraform-aws-eks-node-group
  node_groups = flatten([for m in values(module.region_node_group)[*].region_node_groups : values(m)])

  # node_group_arns is a list of all the node group ARNs in the cluster
  node_group_arns      = compact([for group in local.node_groups : group.eks_node_group_arn])
  node_group_role_arns = compact([for group in local.node_groups : group.eks_node_group_role_arn])
}

module "region_node_group" {
  for_each = module.this.enabled ? var.node_groups : {}

  source = "./modules/node_group_by_region"

  availability_zones = each.value.availability_zones == null ? local.node_group_default_availability_zones : each.value.availability_zones
  attributes         = flatten(concat(var.attributes, [each.key], [var.color], each.value.attributes == null ? var.node_group_defaults.attributes : each.value.attributes))

  node_group_size = module.this.enabled ? {
    desired_size = each.value.desired_group_size == null ? var.node_group_defaults.desired_group_size : each.value.desired_group_size
    min_size = each.value.min_group_size == null ? (
      var.node_group_defaults.min_group_size == null ? (
        length(each.value.availability_zones == null ? local.node_group_default_availability_zones : each.value.availability_zones)
      ) : var.node_group_defaults.min_group_size
    ) : each.value.min_group_size
    max_size = each.value.max_group_size == null ? var.node_group_defaults.max_group_size : each.value.max_group_size
  } : null

  cluster_context = module.this.enabled ? {
    cluster_name               = module.eks_cluster.eks_cluster_id
    create_before_destroy      = each.value.create_before_destroy == null ? var.node_group_defaults.create_before_destroy : each.value.create_before_destroy
    disk_size                  = each.value.disk_size == null ? var.node_group_defaults.disk_size : each.value.disk_size
    cluster_autoscaler_enabled = each.value.cluster_autoscaler_enabled == null ? var.node_group_defaults.cluster_autoscaler_enabled : each.value.cluster_autoscaler_enabled
    instance_types             = each.value.instance_types == null ? var.node_group_defaults.instance_types : each.value.instance_types
    ami_type                   = each.value.ami_type == null ? var.node_group_defaults.ami_type : each.value.ami_type
    ami_release_version        = each.value.ami_release_version == null ? var.node_group_defaults.ami_release_version : each.value.ami_release_version
    kubernetes_version         = each.value.kubernetes_version == null ? local.node_group_default_kubernetes_version : each.value.kubernetes_version
    kubernetes_labels          = each.value.kubernetes_labels == null ? var.node_group_defaults.kubernetes_labels : each.value.kubernetes_labels
    kubernetes_taints          = each.value.kubernetes_taints == null ? var.node_group_defaults.kubernetes_taints : each.value.kubernetes_taints
    resources_to_tag           = each.value.resources_to_tag == null ? var.node_group_defaults.resources_to_tag : each.value.resources_to_tag
    subnet_type_tag_key        = local.subnet_type_tag_key
    vpc_id                     = local.vpc_id

    # See "Ensure ordering of resource creation" comment above for explanation
    # of "module_depends_on"
    module_depends_on = module.eks_cluster.kubernetes_config_map_id
  } : null

  context = module.this.context
}
