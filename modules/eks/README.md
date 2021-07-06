# Component: `eks`

This component is responsible for provisioning an end-to-end EKS Cluster, including managed node groups.

## Usage

**Stack Level**: Regional

Here's an example snippet for how to use this component.

```yaml
components:
  terraform:
    eks:
      vars:
        cluster_kubernetes_version: "1.19"
        region_availability_zones: ["us-east-1b", "us-east-1c", "us-east-1d"]
        public_access_cidrs: ["72.107.0.0/24"]
        managed_node_groups_enabled: true
        node_groups: # null means use default set in defaults.auto.tf.vars
          main:
            # values of `null` will be replaced with default values
            # availability_zones = null will create 1 auto scaling group in
            # each availability zone in region_availability_zones
            availability_zones: null

            desired_group_size: 3 # number of instances to start with, must be >= number of AZs
            min_group_size: 3 # must be  >= number of AZs
            max_group_size: 6

            # Can only set one of ami_release_version or kubernetes_version
            # Leave both null to use latest AMI for Cluster Kubernetes version
            kubernetes_version: null # use cluster Kubernetes version
            ami_release_version: null # use latest AMI for Kubernetes version

            attributes: []
            create_before_destroy: true
            disk_size: 100
            cluster_autoscaler_enabled: true
            instance_types:
              - t3.medium
            ami_type: AL2_x86_64 # use "AL2_x86_64" for standard instances, "AL2_x86_64_GPU" for GPU instances
            kubernetes_labels: {}
            kubernetes_taints: {}
            resources_to_tag:
              - instance
              - volume
            tags: null
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.32 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 1.13 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.1 |
| <a name="requirement_template"></a> [template](#requirement\_template) | ~> 2.2 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | ~> 0.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.32 |
| <a name="provider_external"></a> [external](#provider\_external) | ~> 2.1 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_delegated_roles"></a> [delegated\_roles](#module\_delegated\_roles) | cloudposse/stack-config/yaml//modules/remote-state | 0.13.0 |
| <a name="module_eks"></a> [eks](#module\_eks) | cloudposse/stack-config/yaml//modules/remote-state | 0.13.0 |
| <a name="module_eks_cluster"></a> [eks\_cluster](#module\_eks\_cluster) | cloudposse/eks-cluster/aws | 0.37.0 |
| <a name="module_iam_roles"></a> [iam\_roles](#module\_iam\_roles) | ../account-map/modules/iam-roles |  |
| <a name="module_primary_roles"></a> [primary\_roles](#module\_primary\_roles) | cloudposse/stack-config/yaml//modules/remote-state | 0.13.0 |
| <a name="module_region_node_group"></a> [region\_node\_group](#module\_region\_node\_group) | ./modules/node_group_by_region |  |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | cloudposse/stack-config/yaml//modules/remote-state | 0.13.0 |
| <a name="module_workers_role"></a> [workers\_role](#module\_workers\_role) | cloudposse/stack-config/yaml//modules/remote-state | 0.13.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy_attachment.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_arn.roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/arn) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [external_external.awscli](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [terraform_remote_state.delegated_roles](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.eks](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.primary_roles](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of CIDR blocks to be allowed to connect to the EKS cluster | `list(string)` | `[]` | no |
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | List of Security Group IDs to be allowed to connect to the EKS cluster | `list(string)` | `[]` | no |
| <a name="input_apply_config_map_aws_auth"></a> [apply\_config\_map\_aws\_auth](#input\_apply\_config\_map\_aws\_auth) | Whether to execute `kubectl apply` to apply the ConfigMap to allow worker nodes to join the EKS cluster | `bool` | `true` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_availability_zone_abbreviation_type"></a> [availability\_zone\_abbreviation\_type](#input\_availability\_zone\_abbreviation\_type) | Type of Availability Zone abbreviation (either `fixed` or `short`) to use in names. See https://github.com/cloudposse/terraform-aws-utils for details. | `string` | `"fixed"` | no |
| <a name="input_cluster_encryption_config_enabled"></a> [cluster\_encryption\_config\_enabled](#input\_cluster\_encryption\_config\_enabled) | Set to `true` to enable Cluster Encryption Configuration | `bool` | `false` | no |
| <a name="input_cluster_encryption_config_kms_key_deletion_window_in_days"></a> [cluster\_encryption\_config\_kms\_key\_deletion\_window\_in\_days](#input\_cluster\_encryption\_config\_kms\_key\_deletion\_window\_in\_days) | Cluster Encryption Config KMS Key Resource argument - key deletion windows in days post destruction | `number` | `10` | no |
| <a name="input_cluster_encryption_config_kms_key_enable_key_rotation"></a> [cluster\_encryption\_config\_kms\_key\_enable\_key\_rotation](#input\_cluster\_encryption\_config\_kms\_key\_enable\_key\_rotation) | Cluster Encryption Config KMS Key Resource argument - enable kms key rotation | `bool` | `true` | no |
| <a name="input_cluster_encryption_config_kms_key_id"></a> [cluster\_encryption\_config\_kms\_key\_id](#input\_cluster\_encryption\_config\_kms\_key\_id) | Specify KMS Key Id ARN to use for cluster encryption config | `string` | `""` | no |
| <a name="input_cluster_encryption_config_kms_key_policy"></a> [cluster\_encryption\_config\_kms\_key\_policy](#input\_cluster\_encryption\_config\_kms\_key\_policy) | Cluster Encryption Config KMS Key Resource argument - key policy | `string` | `null` | no |
| <a name="input_cluster_encryption_config_resources"></a> [cluster\_encryption\_config\_resources](#input\_cluster\_encryption\_config\_resources) | Cluster Encryption Config Resources to encrypt, e.g. ['secrets'] | `list(any)` | <pre>[<br>  "secrets"<br>]</pre> | no |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default to AWS EKS resource and it is `false` | `bool` | `false` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default to AWS EKS resource and it is `true` | `bool` | `true` | no |
| <a name="input_cluster_kubernetes_version"></a> [cluster\_kubernetes\_version](#input\_cluster\_kubernetes\_version) | Desired Kubernetes master version. If you do not specify a value, the latest available version is used | `string` | `null` | no |
| <a name="input_cluster_log_retention_period"></a> [cluster\_log\_retention\_period](#input\_cluster\_log\_retention\_period) | Number of days to retain cluster logs. Requires `enabled_cluster_log_types` to be set. See https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. | `number` | `0` | no |
| <a name="input_color"></a> [color](#input\_color) | The cluster stage represented by a color; e.g. blue, green | `string` | `""` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | <pre>object({<br>    enabled             = bool<br>    namespace           = string<br>    environment         = string<br>    stage               = string<br>    name                = string<br>    delimiter           = string<br>    attributes          = list(string)<br>    tags                = map(string)<br>    additional_tag_map  = map(string)<br>    regex_replace_chars = string<br>    label_order         = list(string)<br>    id_length_limit     = number<br>  })</pre> | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_order": [],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_delegated_iam_roles"></a> [delegated\_iam\_roles](#input\_delegated\_iam\_roles) | Delegated IAM roles to add to `aws-auth` ConfigMap | <pre>list(object({<br>    role   = string<br>    groups = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_enable_vpn_access"></a> [enable\_vpn\_access](#input\_enable\_vpn\_access) | Enable VPN access via the HAL VPN; see vpn project | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | A list of the desired control plane logging to enable. For more information, see https://docs.aws.amazon.com/en_us/eks/latest/userguide/control-plane-logs.html. Possible values [`api`, `audit`, `authenticator`, `controllerManager`, `scheduler`] | `list(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_iam_primary_roles_stage_name"></a> [iam\_primary\_roles\_stage\_name](#input\_iam\_primary\_roles\_stage\_name) | The name of the stage where the IAM primary roles are provisioned | `string` | `"identity"` | no |
| <a name="input_iam_roles_environment_name"></a> [iam\_roles\_environment\_name](#input\_iam\_roles\_environment\_name) | The name of the environment where the IAM roles are provisioned | `string` | `"gbl"` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters.<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_import_role_arn"></a> [import\_role\_arn](#input\_import\_role\_arn) | IAM Role ARN to use when importing a resource | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_managed_node_groups_enabled"></a> [managed\_node\_groups\_enabled](#input\_managed\_node\_groups\_enabled) | Set false to prevent the creation of EKS managed node groups. | `bool` | `true` | no |
| <a name="input_map_additional_aws_accounts"></a> [map\_additional\_aws\_accounts](#input\_map\_additional\_aws\_accounts) | Additional AWS account numbers to add to `aws-auth` ConfigMap | `list(string)` | `[]` | no |
| <a name="input_map_additional_iam_users"></a> [map\_additional\_iam\_users](#input\_map\_additional\_iam\_users) | Additional IAM users to add to `aws-auth` ConfigMap | <pre>list(object({<br>    userarn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_map_additional_worker_roles"></a> [map\_additional\_worker\_roles](#input\_map\_additional\_worker\_roles) | AWS IAM Role ARNs of worker nodes to add to `aws-auth` ConfigMap | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_node_group_defaults"></a> [node\_group\_defaults](#input\_node\_group\_defaults) | Defaults for node groups in the cluster | <pre>object({<br>    ami_release_version        = string<br>    ami_type                   = string<br>    attributes                 = list(string)<br>    availability_zones         = list(string) # set to null to use var.region_availability_zones<br>    cluster_autoscaler_enabled = bool<br>    create_before_destroy      = bool<br>    desired_group_size         = number<br>    disk_encryption_enabled    = bool<br>    disk_size                  = number<br>    instance_types             = list(string)<br>    kubernetes_labels          = map(string)<br>    kubernetes_taints          = map(string)<br>    kubernetes_version         = string # set to null to use cluster_kubernetes_version<br>    max_group_size             = number<br>    min_group_size             = number<br>    resources_to_tag           = list(string)<br>    tags                       = map(string)<br>  })</pre> | <pre>{<br>  "ami_release_version": null,<br>  "ami_type": null,<br>  "attributes": null,<br>  "availability_zones": null,<br>  "cluster_autoscaler_enabled": true,<br>  "create_before_destroy": true,<br>  "desired_group_size": 1,<br>  "disk_encryption_enabled": true,<br>  "disk_size": 20,<br>  "instance_types": [<br>    "t3.medium"<br>  ],<br>  "kubernetes_labels": null,<br>  "kubernetes_taints": null,<br>  "kubernetes_version": null,<br>  "max_group_size": 100,<br>  "min_group_size": null,<br>  "resources_to_tag": null,<br>  "tags": null<br>}</pre> | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | List of objects defining a node group for the cluster | <pre>map(object({<br>    # EKS AMI version to use, e.g. "1.16.13-20200821" (no "v").<br>    ami_release_version = string<br>    # Type of Amazon Machine Image (AMI) associated with the EKS Node Group<br>    ami_type = string<br>    # Additional attributes (e.g. `1`) for the node group<br>    attributes = list(string)<br>    # will create 1 auto scaling group in each specified availability zone<br>    availability_zones = list(string)<br>    # Whether to enable Node Group to scale its AutoScaling Group<br>    cluster_autoscaler_enabled = bool<br>    # True to create new node_groups before deleting old ones, avoiding a temporary outage<br>    create_before_destroy = bool<br>    # Desired number of worker nodes when initially provisioned<br>    desired_group_size = number<br>    # Enable disk encryption for the created launch template (if we aren't provided with an existing launch template)<br>    disk_encryption_enabled = bool<br>    # Disk size in GiB for worker nodes. Terraform will only perform drift detection if a configuration value is provided.<br>    disk_size = number<br>    # Set of instance types associated with the EKS Node Group. Terraform will only perform drift detection if a configuration value is provided.<br>    instance_types = list(string)<br>    # Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed<br>    kubernetes_labels = map(string)<br>    # Key-value mapping of Kubernetes taints.<br>    kubernetes_taints = map(string)<br>    # Desired Kubernetes master version. If you do not specify a value, the latest available version is used<br>    kubernetes_version = string<br>    # The maximum size of the AutoScaling Group<br>    max_group_size = number<br>    # The minimum size of the AutoScaling Group<br>    min_group_size = number<br>    # List of auto-launched resource types to tag<br>    resources_to_tag = list(string)<br>    tags             = map(string)<br>  }))</pre> | `{}` | no |
| <a name="input_oidc_provider_enabled"></a> [oidc\_provider\_enabled](#input\_oidc\_provider\_enabled) | Create an IAM OIDC identity provider for the cluster, then you can create IAM roles to associate with a service account in the cluster, instead of using kiam or kube2iam. For more information, see https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html | `bool` | n/a | yes |
| <a name="input_primary_iam_roles"></a> [primary\_iam\_roles](#input\_primary\_iam\_roles) | Primary IAM roles to add to `aws-auth` ConfigMap | <pre>list(object({<br>    role   = string<br>    groups = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_public_access_cidrs"></a> [public\_access\_cidrs](#input\_public\_access\_cidrs) | Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0. | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_region_availability_zones"></a> [region\_availability\_zones](#input\_region\_availability\_zones) | AWS Availability Zones in which to deploy multi-AZ resources | `list(string)` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_subnet_type_tag_key"></a> [subnet\_type\_tag\_key](#input\_subnet\_type\_tag\_key) | The tag used to find the private subnets to find by availability zone. If null, will be looked up in vpc outputs. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| <a name="input_tfstate_account_id"></a> [tfstate\_account\_id](#input\_tfstate\_account\_id) | The ID of the account where the Terraform remote state backend is provisioned | `string` | `""` | no |
| <a name="input_tfstate_assume_role"></a> [tfstate\_assume\_role](#input\_tfstate\_assume\_role) | Set to false to use the caller's role to access the Terraform remote state | `bool` | `true` | no |
| <a name="input_tfstate_bucket_environment_name"></a> [tfstate\_bucket\_environment\_name](#input\_tfstate\_bucket\_environment\_name) | The name of the environment for Terraform state bucket | `string` | `""` | no |
| <a name="input_tfstate_bucket_stage_name"></a> [tfstate\_bucket\_stage\_name](#input\_tfstate\_bucket\_stage\_name) | The name of the stage for Terraform state bucket | `string` | `"root"` | no |
| <a name="input_tfstate_existing_role_arn"></a> [tfstate\_existing\_role\_arn](#input\_tfstate\_existing\_role\_arn) | The ARN of the existing IAM Role to access the Terraform remote state. If not provided and `remote_state_assume_role` is `true`, a role will be constructed from `remote_state_role_arn_template` | `string` | `""` | no |
| <a name="input_tfstate_role_arn_template"></a> [tfstate\_role\_arn\_template](#input\_tfstate\_role\_arn\_template) | IAM Role ARN template for accessing the Terraform remote state | `string` | `"arn:aws:iam::%s:role/%s-%s-%s-%s"` | no |
| <a name="input_tfstate_role_environment_name"></a> [tfstate\_role\_environment\_name](#input\_tfstate\_role\_environment\_name) | The name of the environment for Terraform state IAM role | `string` | `"gbl"` | no |
| <a name="input_tfstate_role_name"></a> [tfstate\_role\_name](#input\_tfstate\_role\_name) | IAM Role name for accessing the Terraform remote state | `string` | `"terraform"` | no |
| <a name="input_tfstate_role_stage_name"></a> [tfstate\_role\_stage\_name](#input\_tfstate\_role\_stage\_name) | The name of the stage for Terraform state IAM role | `string` | `"root"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_auth_worker_roles"></a> [eks\_auth\_worker\_roles](#output\_eks\_auth\_worker\_roles) | List of worker IAM roles that were included in the `auth-map` ConfigMap. |
| <a name="output_eks_cluster_arn"></a> [eks\_cluster\_arn](#output\_eks\_cluster\_arn) | The Amazon Resource Name (ARN) of the cluster |
| <a name="output_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#output\_eks\_cluster\_endpoint) | The endpoint for the Kubernetes API server |
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | The name of the cluster |
| <a name="output_eks_cluster_identity_oidc_issuer"></a> [eks\_cluster\_identity\_oidc\_issuer](#output\_eks\_cluster\_identity\_oidc\_issuer) | The OIDC Identity issuer for the cluster |
| <a name="output_eks_cluster_managed_security_group_id"></a> [eks\_cluster\_managed\_security\_group\_id](#output\_eks\_cluster\_managed\_security\_group\_id) | Security Group ID that was created by EKS for the cluster. EKS creates a Security Group and applies it to ENI that is attached to EKS Control Plane master nodes and to any managed workloads |
| <a name="output_eks_cluster_version"></a> [eks\_cluster\_version](#output\_eks\_cluster\_version) | The Kubernetes server version of the cluster |
| <a name="output_eks_managed_node_workers_role_arns"></a> [eks\_managed\_node\_workers\_role\_arns](#output\_eks\_managed\_node\_workers\_role\_arns) | List of ARNs for workers in managed node groups |
| <a name="output_eks_node_group_arns"></a> [eks\_node\_group\_arns](#output\_eks\_node\_group\_arns) | ARN of the worker nodes IAM role |
| <a name="output_eks_node_group_count"></a> [eks\_node\_group\_count](#output\_eks\_node\_group\_count) | Count of the worker nodes |
| <a name="output_eks_node_group_ids"></a> [eks\_node\_group\_ids](#output\_eks\_node\_group\_ids) | EKS Cluster name and EKS Node Group name separated by a colon |
| <a name="output_eks_node_group_role_names"></a> [eks\_node\_group\_role\_names](#output\_eks\_node\_group\_role\_names) | Name of the worker nodes IAM role |
| <a name="output_eks_node_group_statuses"></a> [eks\_node\_group\_statuses](#output\_eks\_node\_group\_statuses) | Status of the EKS Node Group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## References

- [cloudposse/terraform-aws-components](https://github.com/cloudposse/terraform-aws-components/tree/master/modules/eks) - Cloud Posse's upstream component

[<img src="https://cloudposse.com/logo-300x69.svg" height="32" align="right"/>](https://cpco.io/component)

