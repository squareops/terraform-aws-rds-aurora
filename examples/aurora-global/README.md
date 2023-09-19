<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.30 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora"></a> [aurora](#module\_aurora) | git@github.com:sq-ia/terraform-aws-rds-aurora.git | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aurora_cluster_endpoint"></a> [aurora\_cluster\_endpoint](#output\_aurora\_cluster\_endpoint) | The endpoint URL of the Aurora cluster |
| <a name="output_aurora_cluster_master_password"></a> [aurora\_cluster\_master\_password](#output\_aurora\_cluster\_master\_password) | The master password for the Aurora cluster |
| <a name="output_aurora_cluster_master_username"></a> [aurora\_cluster\_master\_username](#output\_aurora\_cluster\_master\_username) | The master username for the Aurora cluster |
| <a name="output_aurora_cluster_reader_endpoint"></a> [aurora\_cluster\_reader\_endpoint](#output\_aurora\_cluster\_reader\_endpoint) | The reader endpoint URL of the Aurora cluster |
| <a name="output_aurora_security_group_id"></a> [aurora\_security\_group\_id](#output\_aurora\_security\_group\_id) | The security group ID associated with the Aurora cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
