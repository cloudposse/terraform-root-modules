
locals {
  ssm_enabled = module.this.enabled && var.aws_ssm_enabled
  # worker_role_arns does not include managed node group role ARNs created in this invocation
  all_worker_role_arns = local.ssm_enabled ? toset(
    distinct(compact(concat(local.worker_role_arns, local.node_group_role_arns)))
  ) : []
  worker_role_names = local.ssm_enabled ? toset([
    for arn in local.all_worker_role_arns : split("/", data.aws_arn.roles[arn].resource)[1]]
  ) : []
}

data "aws_arn" "roles" {
  for_each = local.ssm_enabled ? local.all_worker_role_arns : []
  arn      = each.key
}

# Attach Amazon's managed policy for SSM managed instance
resource "aws_iam_role_policy_attachment" "ssm_core" {
  for_each   = local.ssm_enabled ? local.worker_role_names : []
  role       = each.key
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach Amazon's managed policy for EventBridge and CloudWatch access
resource "aws_iam_role_policy_attachment" "cloudwatch" {
  for_each   = local.ssm_enabled ? local.worker_role_names : []
  role       = each.key
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
