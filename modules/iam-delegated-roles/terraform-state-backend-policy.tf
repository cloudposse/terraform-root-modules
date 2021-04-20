data "aws_iam_policy_document" "tfstate" {
  count = module.this.stage == var.tfstate_backend_stage_name ? 1 : 0

  statement {
    sid     = "TerraformStateBackendS3Bucket"
    effect  = "Allow"
    actions = ["s3:ListBucket", "s3:GetObject", "s3:PutObject"]
    resources = [
      module.tfstate.outputs.tfstate_backend_s3_bucket_arn,
      "${module.tfstate.outputs.tfstate_backend_s3_bucket_arn}/*"
    ]
  }

  statement {
    sid       = "TerraformStateBackendDynamoDbTable"
    effect    = "Allow"
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
    resources = [module.tfstate.outputs.tfstate_backend_dynamodb_table_arn]
  }
}

resource "aws_iam_policy" "tfstate" {
  count = module.this.stage == var.tfstate_backend_stage_name ? 1 : 0

  name   = format("%s-terraform-state-backend", module.label.id)
  policy = data.aws_iam_policy_document.tfstate[0].json
}
