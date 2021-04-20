# https://github.com/kubernetes-sigs/external-dns

module "external-dns" {
  source = "./modules/service-account"

  service_account_name      = "external-dns"
  service_account_namespace = "kube-system"
  aws_iam_policy_document   = data.aws_iam_policy_document.external_dns.json

  cluster_context = local.cluster_context
  context         = module.this.context
}

data "aws_iam_policy_document" "external_dns" {
  statement {
    sid = "GrantChangeResourceRecordSets"

    actions = [
      "route53:ChangeResourceRecordSets"
    ]

    effect    = "Allow"
    resources = formatlist("arn:aws:route53:::hostedzone/%s", local.zone_ids)
  }

  statement {
    sid = "GrantListHostedZonesListResourceRecordSets"

    actions = [
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
      "route53:ListResourceRecordSets"
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}
