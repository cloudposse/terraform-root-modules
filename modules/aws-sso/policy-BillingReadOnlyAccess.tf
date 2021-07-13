locals {
  billing_read_only_access_permission_set = [{
    name               = "BillingReadOnlyAccess",
    description        = "Allow users to view bills in the billing console",
    relay_state        = "",
    session_duration   = "",
    tags               = {},
    inline_policy      = ""
    policy_attachments = ["arn:aws:iam::aws:policy/AWSBillingReadOnlyAccess"]
  }]
}
