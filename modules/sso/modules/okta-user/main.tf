resource "aws_iam_user" "default" {
  name          = module.this.id
  tags          = module.this.tags
  force_destroy = true
}

# https://saml-doc.okta.com/SAML_Docs/How-to-Configure-SAML-2.0-for-Amazon-Web-Service.html
data "aws_iam_policy_document" "default" {
  statement {
    sid = "AllowOktaUserToListIamRoles"
    actions = [
      "iam:ListRoles",
      "iam:ListAccountAliases"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "default" {
  name        = module.this.id
  description = "Policy for Okta user"
  policy      = data.aws_iam_policy_document.default.json
}

resource "aws_iam_user_policy_attachment" "default" {
  user       = aws_iam_user.default.name
  policy_arn = aws_iam_policy.default.arn
}

# Generate API credentials
resource "aws_iam_access_key" "default" {
  user = aws_iam_user.default.name
}

resource "aws_ssm_parameter" "okta_user_access_key_id" {
  name        = "/sso/${module.this.id}/access_key_id"
  value       = aws_iam_access_key.default.id
  description = "Access Key ID for Okta user"
  type        = "SecureString"
  key_id      = var.kms_alias_name
  overwrite   = true
}

resource "aws_ssm_parameter" "okta_user_secret_access_key" {
  name        = "/sso/${module.this.id}/secret_access_key"
  value       = aws_iam_access_key.default.secret
  description = "Secret Access Key for Okta user"
  type        = "SecureString"
  key_id      = var.kms_alias_name
  overwrite   = true
}
