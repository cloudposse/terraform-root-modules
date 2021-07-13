# Component: `vpc-peering`

This component is responsible for creating a peering connection between two VPCs existing in different AWS accounts.

## Usage

**Stack Level**: Regional

Here's an example snippet for how to use this component.

`stacks/vpc-peering/vpc-peering-defaults.yaml` (default VPC peering settings for all accounts):

```yaml
components:
  terraform:
    vpc-peering:
      vars:
        requester_allow_remote_vpc_dns_resolution: true
        accepter_allow_remote_vpc_dns_resolution: true
        accepter_region: <REGION>
        accepter_vpc_id: <VPC ID>
        accepter_aws_assume_role_arn: arn:aws:iam::<LEGACY ACCOUNT ID>:role/-vpc-peering
```

`stacks/ue1-sandbox.yaml`:

```yaml
import:
  - vpc-peering/vpc-peering-defaults
```


## Legacy Account Configuration

The `vpc-peering` component peers the `dev`, `prod`, `sandbox` and `staging` VPCs to a VPC in the legacy account.

The `dev`, `prod`, `sandbox` and `staging` VPCs are the requesters of the VPC peering connection,
while the legacy VPC is the accepter of the peering connection.

To provision VPC peering and all related resources with Terraform, we need the following information from the legacy account:

  - Legacy account ID
  - Legacy VPC ID
  - Legacy AWS region
  - Legacy IAM role (the role must be created in the legacy account with permissions to create VPC peering and routes).
    The name of the role could be `-vpc-peering` and the ARN of the role should look like `arn:aws:iam::<LEGACY ACCOUNT ID>:role/-vpc-peering`


### Legacy Account IAM Role

In the legacy account, create IAM role `-vpc-peering` with the following policy:

__NOTE:__ Replace `<LEGACY ACCOUNT ID>` with the ID of the legacy account.

```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:CreateRoute",
          "ec2:DeleteRoute"
        ],
        "Resource": "arn:aws:ec2:*:<LEGACY ACCOUNT ID>:route-table/*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeVpcPeeringConnections",
          "ec2:DescribeVpcs",
          "ec2:ModifyVpcPeeringConnectionOptions",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcAttribute",
          "ec2:DescribeRouteTables"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:AcceptVpcPeeringConnection",
          "ec2:DeleteVpcPeeringConnection",
          "ec2:CreateVpcPeeringConnection",
          "ec2:RejectVpcPeeringConnection"
        ],
        "Resource": [
          "arn:aws:ec2:*:<LEGACY ACCOUNT ID>:vpc-peering-connection/*",
          "arn:aws:ec2:*:<LEGACY ACCOUNT ID>:vpc/*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
          "ec2:DeleteTags",
          "ec2:CreateTags"
        ],
        "Resource": "arn:aws:ec2:*:<LEGACY ACCOUNT ID>:vpc-peering-connection/*"
      }
    ]
  }
```

Add the following trust policy to the IAM role:

```json
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": [
            "arn:aws:iam::<ACCOUNT ID>:root"
          ]
        },
        "Action": "sts:AssumeRole",
        "Condition": {}
      }
    ]
  }
```

The trust policy allows the `identity` account to assume the role (and provision all the resources in the legacy account).

<br>

## Provisioning

Provision the VPC peering connections in the `dev`, `prod`, `sandbox` and `staging` accounts by executing
the following commands:

```sh
atmos terraform plan vpc-peering -s ue1-sandbox
atmos terraform apply vpc-peering -s ue1-sandbox

atmos terraform plan vpc-peering -s ue1-dev
atmos terraform apply vpc-peering -s ue1-dev

atmos terraform plan vpc-peering -s ue1-staging
atmos terraform apply vpc-peering -s ue1-staging

atmos terraform plan vpc-peering -s ue1-prod
atmos terraform apply vpc-peering -s ue1-prod
```

<br>

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 1.3 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_roles"></a> [iam\_roles](#module\_iam\_roles) | ../account-map/modules/iam-roles | n/a |
| <a name="module_requester_vpc"></a> [requester\_vpc](#module\_requester\_vpc) | cloudposse/stack-config/yaml//modules/remote-state | 0.13.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |
| <a name="module_vpc_peering"></a> [vpc\_peering](#module\_vpc\_peering) | cloudposse/vpc-peering-multi-account/aws | 0.16.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accepter_allow_remote_vpc_dns_resolution"></a> [accepter\_allow\_remote\_vpc\_dns\_resolution](#input\_accepter\_allow\_remote\_vpc\_dns\_resolution) | Allow accepter VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the requester VPC | `bool` | `true` | no |
| <a name="input_accepter_aws_assume_role_arn"></a> [accepter\_aws\_assume\_role\_arn](#input\_accepter\_aws\_assume\_role\_arn) | Accepter AWS assume role ARN | `string` | n/a | yes |
| <a name="input_accepter_region"></a> [accepter\_region](#input\_accepter\_region) | Accepter AWS region | `string` | n/a | yes |
| <a name="input_accepter_vpc_id"></a> [accepter\_vpc\_id](#input\_accepter\_vpc\_id) | Accepter VPC ID | `string` | n/a | yes |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_auto_accept"></a> [auto\_accept](#input\_auto\_accept) | Automatically accept peering request | `bool` | `true` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_import_profile_name"></a> [import\_profile\_name](#input\_import\_profile\_name) | AWS Profile name to use when importing a resource | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_requester_allow_remote_vpc_dns_resolution"></a> [requester\_allow\_remote\_vpc\_dns\_resolution](#input\_requester\_allow\_remote\_vpc\_dns\_resolution) | Allow requester VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the accepter VPC | `bool` | `true` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_peering"></a> [vpc\_peering](#output\_vpc\_peering) | VPC peering outputs |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

- [cloudposse/terraform-aws-components](https://github.com/cloudposse/terraform-aws-components/tree/master/modules/TODO) - Cloud Posse's upstream component

[<img src="https://cloudposse.com/logo-300x69.svg" height="32" align="right"/>](https://cpco.io/component)
