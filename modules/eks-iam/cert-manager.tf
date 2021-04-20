# https://cert-manager.io/docs/configuration/acme/dns01/route53/

module "cert-manager" {
  source = "./modules/service-account"

  service_account_name      = "cert-manager"
  service_account_namespace = "cert-manager"
  aws_iam_policy_document   = data.aws_iam_policy_document.cert_manager.json

  cluster_context = local.cluster_context
  context         = module.this.context
}

data "aws_iam_policy_document" "cert_manager" {
  statement {
    sid = "GrantGetChange"

    actions = [
      "route53:GetChange"
    ]

    effect    = "Allow"
    resources = ["arn:aws:route53:::change/*"]
  }

  statement {
    sid = "GrantChangeResourceRecordSets"

    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets"
    ]

    effect    = "Allow"
    resources = formatlist("arn:aws:route53:::hostedzone/%s", local.zone_ids)
  }

  statement {
    sid = "GrantListHostedZonesListResourceRecordSets"

    actions = [
      "route53:ListHostedZonesByName"
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}
