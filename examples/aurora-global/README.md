<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.30 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.30 |
| <a name="provider_aws.secondary"></a> [aws.secondary](#provider\_aws.secondary) | >= 4.30 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora"></a> [aurora](#module\_aurora) | squareops/rds-aurora/aws | n/a |
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | n/a |
| <a name="module_secondary_vpc"></a> [secondary\_vpc](#module\_secondary\_vpc) | squareops/vpc/aws | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | squareops/vpc/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_availability_zones.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aurora_cluster_master_password"></a> [aurora\_cluster\_master\_password](#output\_aurora\_cluster\_master\_password) | The master password for the Aurora cluster |
| <a name="output_aurora_cluster_master_username"></a> [aurora\_cluster\_master\_username](#output\_aurora\_cluster\_master\_username) | The master username for the Aurora cluster |
| <a name="output_aurora_primary_cluster_endpoint"></a> [aurora\_primary\_cluster\_endpoint](#output\_aurora\_primary\_cluster\_endpoint) | The endpoint URL of the Aurora cluster |
| <a name="output_aurora_primary_cluster_reader_endpoint"></a> [aurora\_primary\_cluster\_reader\_endpoint](#output\_aurora\_primary\_cluster\_reader\_endpoint) | The reader endpoint URL of the Aurora cluster |
| <a name="output_aurora_secondary_cluster_endpoint"></a> [aurora\_secondary\_cluster\_endpoint](#output\_aurora\_secondary\_cluster\_endpoint) | The endpoint URL of the Aurora cluster seconadry instance |
| <a name="output_aurora_secondary_cluster_reader_endpoint"></a> [aurora\_secondary\_cluster\_reader\_endpoint](#output\_aurora\_secondary\_cluster\_reader\_endpoint) | The reader endpoint URL of the Aurora cluster secondary instance |
| <a name="output_aurora_security_group_id"></a> [aurora\_security\_group\_id](#output\_aurora\_security\_group\_id) | The security group ID associated with the Aurora cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
