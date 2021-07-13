locals {
  billing_administrator_access_permission_set = [{
    name               = "BillingAdministratorAccess",
    description        = "Grants permissions for billing and cost management. This includes viewing account usage and viewing and modifying budgets and payment methods.",
    relay_state        = "",
    session_duration   = "",
    tags               = {},
    inline_policy      = ""
    policy_attachments = ["arn:aws:iam::aws:policy/job-function/Billing"]
  }]
}
