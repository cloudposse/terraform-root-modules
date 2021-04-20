locals {
  github-action-runner_enabled = try(index(local.service_account_list, "github-action-runner"), -1) >= 0
}

module "github-action-runner" {
  source  = "./modules/service-account"
  enabled = local.github-action-runner_enabled

  service_account_name      = "github-action-runner"
  service_account_namespace = "actions-runner-system"
  aws_iam_policy_document   = join("", data.aws_iam_policy_document.github-action-runner.*.json)

  cluster_context = local.cluster_context
  context         = module.this.context
}

data "aws_iam_policy_document" "github-action-runner" {
  count = local.github-action-runner_enabled ? 1 : 0

  statement {
    sid    = "EcrReadWriteDeleteAccess"
    effect = "Allow"

    actions = [
      # This is intended to be everything except create/delete repository
      # and get/set/delete repositoryPolicy
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
      "ecr:PutImageTagMutability",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",
      "ecr:StartImageScan",
      "ecr:BatchDeleteImage",
      "ecr:TagResource",
      "ecr:UntagResource",
      "ecr:GetLifecyclePolicy",
      "ecr:PutLifecyclePolicy",
      "ecr:StartLifecyclePolicyPreview",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:DeleteLifecyclePolicy",
      "ecr:PutImageScanningConfiguration",
    ]
    resources = ["*"]
  }
  statement {
    sid = "AssumeRoles"

    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    effect    = "Allow"
    resources = [module.iam_primary_roles.outputs.role_name_role_arn_map["cicd"]]
  }
}

output "cicd_roles" {
  value = local.github-action-runner_enabled ? [module.github-action-runner.outputs.service_account_role_arn] : null
}
