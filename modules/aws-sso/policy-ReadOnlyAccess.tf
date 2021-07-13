locals {
  read_only_access_permission_set = [{
    name               = "ReadOnlyAccess",
    description        = "Allow Read Only access to the account",
    relay_state        = "",
    session_duration   = "",
    tags               = {},
    inline_policy      = ""
    policy_attachments = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  }]
}
