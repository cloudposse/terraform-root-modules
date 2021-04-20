# https://github.com/kubernetes-sigs/cluster-proportional-autoscaler

module "autoscaler" {
  source = "./modules/service-account"

  service_account_name      = "autoscaler"
  service_account_namespace = "kube-system"
  aws_iam_policy_document   = data.aws_iam_policy_document.autoscaler.json

  cluster_context = local.cluster_context
  context         = module.this.context
}

data "aws_iam_policy_document" "autoscaler" {
  statement {
    sid = "AllowToScaleEKSNodeGroupAutoScalingGroup"

    actions = [
      "ec2:DescribeLaunchTemplateVersions",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:DescribeTags",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeAutoScalingGroups"
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}
