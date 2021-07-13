data "aws_iam_policy_document" "DNSAdministratorAccess" {
  statement {
    sid    = "AllowDNS"
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:CreateHealthCheck",
      "route53:CreateTrafficPolicy",
      "route53:CreateTrafficPolicyInstance",
      "route53:CreateTrafficPolicyVersion",
      "route53:DeleteHealthCheck",
      "route53:DeleteTrafficPolicy",
      "route53:DeleteTrafficPolicyInstance",
      "route53:Get*",
      "route53:List*",
      "route53:UpdateHealthCheck",
      "route53:UpdateTrafficPolicyComment",
      "route53:UpdateTrafficPolicyInstance",
      "route53domains:List*",
    ]

    resources = [
      "*",
    ]
  }
}

locals {
  dns_administrator_access_permission_set = [{
    name               = "DNSRecordAdministratorAccess",
    description        = "Allow DNS Record Admininstrator access to the account, but not zone administration",
    relay_state        = "https://console.aws.amazon.com/route53/",
    session_duration   = "",
    tags               = {},
    inline_policy      = data.aws_iam_policy_document.DNSAdministratorAccess.json,
    policy_attachments = []
  }]
}
