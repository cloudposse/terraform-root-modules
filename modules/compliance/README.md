# Component: `compliance`

This component is responsible for provisioning the baseline security for the organization.

## AWS Services

This component is responsible for deploy several AWS security and compliance-related services across all of the accounts of the AWS organization:

### AWS Config

[AWS Config](https://docs.aws.amazon.com/config/latest/developerguide) is a service that enables you to assess, audit, and evaluate the configurations of your AWS resources. Config continuously monitors and records your AWS resource configurations and allows you to automate the evaluation of recorded configurations against desired configurations.

#### CIS AWS Foundations Benchmark v1.2 Config Rules

A series of [AWS Config Rules](https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-cis-controls.html)
that ensure various controls from the [AWS CIS Foundations Benchmark](https://d1.awsstatic.com/whitepapers/compliance/AWS_CIS_Foundations_Benchmark.pdf) are compliant.

#### Operational Best Practices for HIPAA Security (Conformance Pack)

- https://docs.aws.amazon.com/config/latest/developerguide/operational-best-practices-for-hipaa_security.html
- https://docs.aws.amazon.com/config/latest/developerguide/conformance-packs.html

### AWS Security Hub

[AWS Security Hub](https://docs.aws.amazon.com/securityhub/latest/userguide) provides you with a comprehensive view of your security state in AWS and helps you check your environment against security industry standards and best practices.

Security Hub collects security data from across AWS accounts, services, and supported third-party partner products and helps you analyze your security trends and identify the highest priority security issues.

### Sub-Modules

#### [multi-account-generator](modules/multi-account-generator/)

This component generates a provider configuration and invocation of [single-account](#single-account) for each region that is enabled in the account. This code generation is necessary because certain components of the compliance solution (i.e.AWS Config and AWS Security Hub) require the components to be applied in every region that is enabled in the account. There are 16 default regions that cannot be disabled, so at a minimum, these components have to be deployed across those 16 regions.

#### [single-account](modules/single-account/)

This enables all of compliance-related confguration and resources for a single AWS account and region.

## Usage

**Stack Level**: Regional

Here's an example snippet for how to use this component. Stick this snippet in a file called `compliance.yaml`, then include `compliance` in the `import` section of the primary region's stack in the security account.

```yaml
components:
  terraform:
    compliance:
      vars:
        config_bucket_stage: "audit"
        config_bucket_env: "ue1"
        cloudtrail_bucket_stage: "audit"
        cloudtrail_bucket_env: "ue1"
        central_logging_account: "audit"
        central_resource_collector_account: "security"
        securityhub_central_account: "security"
        config_rules_paths:
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/account.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/acm.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/alb.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/ami.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/apigw.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/asg.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/cloudformation.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/cloudfront.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/cloudtrail.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/cloudwatch.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/cmk.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/codebuild.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/codepipeline.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/dms.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/dynamodb.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/ec2.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/efs.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/eip.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/eks.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/elasticache.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/elasticsearch.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/elb.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/emr.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/fms.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/guardduty.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/iam.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/kms.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/lambda.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/mfa.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/network.yaml
          - https://raw.githubusercontent.com/cloudposse/terraform-aws-config/0.2.0/catalog/vpc.yaml
        securityhub_create_sns_topic: true
        securityhub_enabled_standards:
          - ruleset/cis-aws-foundations-benchmark/v/1.2.0
```

### Related Tasks

As part of the initial bootstrapping of the AWS Organization, a few extra steps need to be taken in order to enable various componets for the entire AWS Organization. Unfortunately, Terraform doesn't support these opeartions, so we use the [turf](https://github.com/cloudposse/turf) cli to assist. This only needs to be done once.

In each account, we need to delete the Default VPCs and the their associated resources:

```sh
turf aws \
  delete-default-vpcs \
  --role arn:aws:iam::999999999999:role/eg-gbl-root-admin \
  --delete
```

Then we run a command to deploy Security Hub across the AWS Organization and designate an organization Admininstrator account for Security Hub:

```sh
turf aws \
  securityhub \
  set-administrator-account \
  -administrator-account-role arn:aws:iam::111111111111:role/eg-gbl-security-admin \
  -root-role arn:aws:iam::999999999999:role/eg-gbl-root-admin \
  --region us-west-2
```

Similarly, to deploy AWS GuardDuty via AWS Organizations:

```sh
turf aws \
  guardduty \
  set-administrator-account \
  -administrator-account-role arn:aws:iam::111111111111:role/eg-gbl-security-admin \
  -root-role arn:aws:iam::999999999999:role/eg-gbl-root-admin \
  --region us-west-2
```

Finally, there are a number of AWS Config controls related to Global Resources (i.e. IAM Roles) that only need to be collected in one region per account. AWS Security Hub raises an error if the checks for these controls are not disabled in the non-Global collector regions. In order to disable these controls, the following command should be run:

```sh
turf aws \
  securityhub \
  disable-global-controls \
  --role arn:aws:iam::999999999999:role/eg-gbl-audit-admin \
  --global-collector-region us-west-2 \
  --cloud-trail-account
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.32 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.1 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 2.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.0 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | ~> 0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.32 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_account_map"></a> [account\_map](#module\_account\_map) | cloudposse/stack-config/yaml//modules/remote-state | 0.13.0 |
| <a name="module_aws_config_label"></a> [aws\_config\_label](#module\_aws\_config\_label) | cloudposse/label/null | 0.22.0 |
| <a name="module_compliance_an1"></a> [compliance\_an1](#module\_compliance\_an1) | ./modules/single-account |  |
| <a name="module_compliance_an2"></a> [compliance\_an2](#module\_compliance\_an2) | ./modules/single-account |  |
| <a name="module_compliance_as0"></a> [compliance\_as0](#module\_compliance\_as0) | ./modules/single-account |  |
| <a name="module_compliance_as1"></a> [compliance\_as1](#module\_compliance\_as1) | ./modules/single-account |  |
| <a name="module_compliance_as2"></a> [compliance\_as2](#module\_compliance\_as2) | ./modules/single-account |  |
| <a name="module_compliance_cc1"></a> [compliance\_cc1](#module\_compliance\_cc1) | ./modules/single-account |  |
| <a name="module_compliance_ec1"></a> [compliance\_ec1](#module\_compliance\_ec1) | ./modules/single-account |  |
| <a name="module_compliance_en1"></a> [compliance\_en1](#module\_compliance\_en1) | ./modules/single-account |  |
| <a name="module_compliance_ew1"></a> [compliance\_ew1](#module\_compliance\_ew1) | ./modules/single-account |  |
| <a name="module_compliance_ew2"></a> [compliance\_ew2](#module\_compliance\_ew2) | ./modules/single-account |  |
| <a name="module_compliance_ew3"></a> [compliance\_ew3](#module\_compliance\_ew3) | ./modules/single-account |  |
| <a name="module_compliance_se1"></a> [compliance\_se1](#module\_compliance\_se1) | ./modules/single-account |  |
| <a name="module_compliance_ue1"></a> [compliance\_ue1](#module\_compliance\_ue1) | ./modules/single-account |  |
| <a name="module_compliance_ue2"></a> [compliance\_ue2](#module\_compliance\_ue2) | ./modules/single-account |  |
| <a name="module_compliance_uw1"></a> [compliance\_uw1](#module\_compliance\_uw1) | ./modules/single-account |  |
| <a name="module_compliance_uw2"></a> [compliance\_uw2](#module\_compliance\_uw2) | ./modules/single-account |  |
| <a name="module_iam_roles"></a> [iam\_roles](#module\_iam\_roles) | ../account-map/modules/iam-roles |  |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |
| <a name="module_utils"></a> [utils](#module\_utils) | cloudposse/utils/aws | 0.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_map_environment_name"></a> [account\_map\_environment\_name](#input\_account\_map\_environment\_name) | The name of the environment where `account_map` is provisioned | `string` | `"gbl"` | no |
| <a name="input_account_map_stage_name"></a> [account\_map\_stage\_name](#input\_account\_map\_stage\_name) | The name of the stage where `account_map` is provisioned | `string` | `"root"` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_central_logging_account"></a> [central\_logging\_account](#input\_central\_logging\_account) | The name of the account that is the centralized logging account. The config rules associated with logging in the <br>catalog (loggingAccountOnly: true) will be installed only in this account. | `string` | n/a | yes |
| <a name="input_central_resource_collector_account"></a> [central\_resource\_collector\_account](#input\_central\_resource\_collector\_account) | The account ID of a central account that will aggregate AWS Config from other accounts | `string` | `null` | no |
| <a name="input_child_resource_collector_accounts"></a> [child\_resource\_collector\_accounts](#input\_child\_resource\_collector\_accounts) | The account IDs of other accounts that will send their AWS Configuration to this account | `set(string)` | `null` | no |
| <a name="input_cloudtrail_bucket_env"></a> [cloudtrail\_bucket\_env](#input\_cloudtrail\_bucket\_env) | The environment of the AWS Cloudtrail S3 Bucket | `string` | n/a | yes |
| <a name="input_cloudtrail_bucket_stage"></a> [cloudtrail\_bucket\_stage](#input\_cloudtrail\_bucket\_stage) | The stage of the AWS Cloudtrail S3 Bucket | `string` | n/a | yes |
| <a name="input_config_bucket_env"></a> [config\_bucket\_env](#input\_config\_bucket\_env) | The environment of the AWS Config S3 Bucket | `string` | n/a | yes |
| <a name="input_config_bucket_stage"></a> [config\_bucket\_stage](#input\_config\_bucket\_stage) | The stage of the AWS Config S3 Bucket | `string` | n/a | yes |
| <a name="input_config_rules_paths"></a> [config\_rules\_paths](#input\_config\_rules\_paths) | n/a | `list` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_enabled_regions"></a> [enabled\_regions](#input\_enabled\_regions) | A list of enabled regions | `set(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_global_environment_name"></a> [global\_environment\_name](#input\_global\_environment\_name) | Global environment name | `string` | `"gbl"` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_import_profile_name"></a> [import\_profile\_name](#input\_import\_profile\_name) | AWS Profile to use when importing a resource | `string` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_privileged"></a> [privileged](#input\_privileged) | True if the default provider already has access to the backend | `bool` | `false` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_root_account_stage_name"></a> [root\_account\_stage\_name](#input\_root\_account\_stage\_name) | The stage name for the root account | `string` | `"root"` | no |
| <a name="input_securityhub_central_account"></a> [securityhub\_central\_account](#input\_securityhub\_central\_account) | The account name of a central account that will aggregate AWS SecurityHub data from other accounts | `string` | `null` | no |
| <a name="input_securityhub_create_sns_topic"></a> [securityhub\_create\_sns\_topic](#input\_securityhub\_create\_sns\_topic) | Flag to indicate whether an SNS topic should be created for notifications. | `bool` | `false` | no |
| <a name="input_securityhub_enabled_standards"></a> [securityhub\_enabled\_standards](#input\_securityhub\_enabled\_standards) | A list of standards to enable in the account | `set(string)` | `[]` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
