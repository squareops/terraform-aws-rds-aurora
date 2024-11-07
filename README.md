## AURORA
![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>
This Terraform module provides a convenient way to create and manage an Amazon Aurora RDS (Relational Database Service) cluster in AWS. It supports creating both Aurora MySQL and Aurora PostgreSQL clusters.
Features

  1. Creates an Amazon Aurora RDS cluster with customizable configuration.
  2. Supports both Aurora MySQL and Aurora PostgreSQL engine types.
  3. Allows for easy management of database instances, replicas, and failover.
  4. Configurable backup retention periods and preferred backup/maintenance windows.
  5. Option to enable encryption at rest using AWS Key Management Service (KMS).
  6. Flexible configuration for database parameter groups and security groups.
  7. Supports provisioning in existing VPCs and subnets.
  8. Enables autoscaling for Aurora MySQL read replicas.
  9. Support for serverless Aurora PostgreSQL and performance insights.
  10. Replication: Replicate data from another Amazon RDS database by specifying the source database identifier.
  11. Snapshot Restore: Restore the database from a specified snapshot ID to easily recreate database instances.

## Usage Example
```hcl
  module "aurora" {
  source                           = "squareops/rds-aurora/aws"
  version                          = "2.1.1"
  role_arn                         = local.role_arn
  external_id                      = local.external_id
  environment                      = local.environment
  port                             = local.port
  vpc_id                           = module.vpc.vpc_id
  family                           = local.family
  subnets                          = module.vpc.database_subnets
  engine                           = local.engine
  engine_version                   = local.db_engine_version
  rds_instance_name                = local.name
  create_security_group            = true
  instance_type                    = local.db_instance_class
  storage_encrypted                = true
  kms_key_arn                      = module.kms.key_arn
  publicly_accessible              = false
  master_username                  = "devuser"
  database_name                    = "devdb"
  apply_immediately                = true
  create_random_password           = true
  skip_final_snapshot              = true #  Keeping final snapshot results in retention of DB options group and hence creates problems during destroy. So use this option wisely.
  snapshot_identifier              = null
  preferred_backup_window          = "03:00-06:00"
  preferred_maintenance_window     = "Mon:00:00-Mon:03:00"
  final_snapshot_identifier_prefix = "prod-snapshot"
  backup_retention_period          = 7
  enable_ssl_connection            = false
  autoscaling_enabled              = true
  autoscaling_max                  = 4
  autoscaling_min                  = 1
  long_query_time                  = 10
  deletion_protection              = false
  predefined_metric_type           = "RDSReaderAverageDatabaseConnections"
  autoscaling_target_connections   = 40
  autoscaling_scale_in_cooldown    = 60
  autoscaling_scale_out_cooldown   = 30
  allowed_cidr_blocks              = local.allowed_cidr_blocks
  allowed_security_groups          = local.allowed_security_groups
}
```
## Security & Compliance [<img src="	https://prowler.pro/wp-content/themes/prowler-pro/assets/img/logo.svg" width="250" align="right" />](https://prowler.pro/)

Security scanning is graciously provided by Prowler. Proowler is the leading fully hosted, cloud-native solution providing continuous cluster security and compliance.

| Benchmark | Description |
|--------|---------------|
| Ensure that encryption is enabled for RDS instances | Enabled for RDS created using this module. |

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
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora"></a> [aurora](#module\_aurora) | terraform-aws-modules/rds-aurora/aws | 8.3.0 |
| <a name="module_aurora_secondary"></a> [aurora\_secondary](#module\_aurora\_secondary) | terraform-aws-modules/rds-aurora/aws | 8.3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_db_parameter_group.rds_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_rds_cluster_parameter_group.rds_cluster_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |
| [aws_rds_global_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_global_cluster) | resource |
| [aws_secretsmanager_secret.secret_master_db](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.rds_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [random_password.master](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_availability_zones.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_availability_zones.secondary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Determines whether major engine upgrades are allowed when changing engine version | `bool` | `false` | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | A list of CIDR blocks which are allowed to access the database | `any` | `[]` | no |
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | A list of Security Group IDs to allow access to the database | `any` | `[]` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any cluster modifications are applied immediately or during the next maintenance window | `bool` | `false` | no |
| <a name="input_autoscaling_cpu"></a> [autoscaling\_cpu](#input\_autoscaling\_cpu) | CPU usage to trigger autoscaling at | `number` | `70` | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling\_enabled](#input\_autoscaling\_enabled) | Whether to enable autoscaling for RDS Aurora (MySQL) read replicas | `bool` | `false` | no |
| <a name="input_autoscaling_max"></a> [autoscaling\_max](#input\_autoscaling\_max) | Maximum number of replicas to allow scaling for | `number` | `3` | no |
| <a name="input_autoscaling_min"></a> [autoscaling\_min](#input\_autoscaling\_min) | Minimum number of replicas to allow scaling for | `number` | `1` | no |
| <a name="input_autoscaling_scale_in_cooldown"></a> [autoscaling\_scale\_in\_cooldown](#input\_autoscaling\_scale\_in\_cooldown) | Cooldown in seconds before allowing further scaling operations after a scale in | `number` | `300` | no |
| <a name="input_autoscaling_scale_out_cooldown"></a> [autoscaling\_scale\_out\_cooldown](#input\_autoscaling\_scale\_out\_cooldown) | Cooldown in seconds before allowing further scaling operations after a scale out | `number` | `300` | no |
| <a name="input_autoscaling_target_connections"></a> [autoscaling\_target\_connections](#input\_autoscaling\_target\_connections) | No of connections on which aurora has to scale if predefined\_metric\_type is RDSReaderAverageDatabaseConnections | `number` | `50` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The number of days to retain backups for | `number` | `null` | no |
| <a name="input_create_monitoring_role"></a> [create\_monitoring\_role](#input\_create\_monitoring\_role) | Set it to true to create IAM role for Enhanced monitoring. | `bool` | `false` | no |
| <a name="input_create_random_password"></a> [create\_random\_password](#input\_create\_random\_password) | Whether to create a random password for the primary database cluster | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Whether to create a security group or not | `bool` | `true` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | The name for an automatically created database on cluster creation | `string` | `""` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | Whether accidental deletion protection is enabled | `bool` | `true` | no |
| <a name="input_enable_egress"></a> [enable\_egress](#input\_enable\_egress) | Set it true if allow outbound traffic in rds security group | `bool` | `true` | no |
| <a name="input_enable_http_endpoint"></a> [enable\_http\_endpoint](#input\_enable\_http\_endpoint) | Whether or not to enable the Data API for a serverless Aurora database engine | `bool` | `false` | no |
| <a name="input_enable_ssl_connection"></a> [enable\_ssl\_connection](#input\_enable\_ssl\_connection) | Whether or not to enable the ssl connection | `bool` | `false` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The name of the database engine to be used for this DB cluster | `string` | `"aurora"` | no |
| <a name="input_engine_mode"></a> [engine\_mode](#input\_engine\_mode) | The database engine mode. Valid values: global, parallelquery, provisioned, serverless, multimaster | `string` | `"provisioned"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The database engine version. Updating this argument results in an outage. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Select enviroment type: dev, demo, prod | `string` | `"demo"` | no |
| <a name="input_external_id"></a> [external\_id](#input\_external\_id) | External ID for assuming role. | `string` | `""` | no |
| <a name="input_family"></a> [family](#input\_family) | Version of aurora DB family being created | `string` | `"aurora-mysql5.7"` | no |
| <a name="input_final_snapshot_identifier_prefix"></a> [final\_snapshot\_identifier\_prefix](#input\_final\_snapshot\_identifier\_prefix) | The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too. | `string` | `"final"` | no |
| <a name="input_global_cluster_enable"></a> [global\_cluster\_enable](#input\_global\_cluster\_enable) | Whether enable global cluster then set it to true | `bool` | `false` | no |
| <a name="input_global_cluster_identifier"></a> [global\_cluster\_identifier](#input\_global\_cluster\_identifier) | Global RDS Cluster Identifier name | `string` | `null` | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled | `bool` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type | `string` | `"db.m5.large"` | no |
| <a name="input_instances_config"></a> [instances\_config](#input\_instances\_config) | Map of cluster instances and any specific/overriding attributes to be created | `map(any)` | <pre>{<br/>  "one": {}<br/>}</pre> | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN.  If storage\_encrypted is set to true and kms\_key\_id is not specified the default KMS key created in your account will be used | `string` | `null` | no |
| <a name="input_long_query_time"></a> [long\_query\_time](#input\_long\_query\_time) | To prevent fast-running queries from being logged in the slow query log, specify a value for the shortest query runtime to be logged, in seconds | `number` | `10` | no |
| <a name="input_manage_master_user_password"></a> [manage\_master\_user\_password](#input\_manage\_master\_user\_password) | Set to true to allow RDS to manage the master user password in Secrets Manager. Cannot be set if `master_password` is provided | `bool` | `false` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | The username for the primary cluster | `string` | `"root"` | no |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for instances. Set to 0 to disble. Default is 0 | `number` | `0` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights is enabled or not | `bool` | `null` | no |
| <a name="input_performance_insights_kms_key_id"></a> [performance\_insights\_kms\_key\_id](#input\_performance\_insights\_kms\_key\_id) | ARN of KMS key to encrypt performance insights data. | `string` | `null` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | Retention period for performance insights data, Either 7 (7 days) or 731 (2 years). | `number` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | The port for the database | `number` | `3306` | no |
| <a name="input_predefined_metric_type"></a> [predefined\_metric\_type](#input\_predefined\_metric\_type) | The metric type to scale on. Valid values are RDSReaderAverageCPUUtilization and RDSReaderAverageDatabaseConnections | `string` | `"RDSReaderAverageDatabaseConnections"` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | The maintenance window for performing database backup | `string` | `""` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | The maintenance window for performing database maintenance | `string` | `""` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Specifies whether the database is publicly accessible over the internet | `bool` | `false` | no |
| <a name="input_random_password_length"></a> [random\_password\_length](#input\_random\_password\_length) | The length of the randomly generated password. (default: 10) | `number` | `16` | no |
| <a name="input_rds_instance_name"></a> [rds\_instance\_name](#input\_rds\_instance\_name) | The name of the RDS instance | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region name where the primary RDS resources will be deployed | `string` | `null` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The ARN of the role to assume. Leave empty if not using assume role. | `string` | `""` | no |
| <a name="input_scaling_configuration"></a> [scaling\_configuration](#input\_scaling\_configuration) | Map of nested attributes with scaling properties. Only valid when engine\_mode is set to `serverless` | `map(string)` | `{}` | no |
| <a name="input_secondary_kms_key_arn"></a> [secondary\_kms\_key\_arn](#input\_secondary\_kms\_key\_arn) | The ARN for the secondary region KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN.  If storage\_encrypted is set to true and kms\_key\_id is not specified the default KMS key created in your account will be used | `string` | `null` | no |
| <a name="input_secondary_region"></a> [secondary\_region](#input\_secondary\_region) | Secondary AWS region name where the Secondary RDS and VPC resources will be deployed | `string` | `null` | no |
| <a name="input_secondary_subnets"></a> [secondary\_subnets](#input\_secondary\_subnets) | List of subnet IDs used by database subnet group created in secondary region | `list(string)` | `[]` | no |
| <a name="input_secondary_vpc_allowed_cidr_blocks"></a> [secondary\_vpc\_allowed\_cidr\_blocks](#input\_secondary\_vpc\_allowed\_cidr\_blocks) | A list of CIDR blocks which are allowed to access the database | `any` | `[]` | no |
| <a name="input_secondary_vpc_allowed_security_groups"></a> [secondary\_vpc\_allowed\_security\_groups](#input\_secondary\_vpc\_allowed\_security\_groups) | A list of Security Group IDs to allow access to the database | `any` | `[]` | no |
| <a name="input_secondary_vpc_id"></a> [secondary\_vpc\_id](#input\_secondary\_vpc\_id) | The secondary VPC in which secondary RDS will be launched | `string` | `""` | no |
| <a name="input_security_group_description"></a> [security\_group\_description](#input\_security\_group\_description) | The description of the security group. If value is set to empty string it will contain cluster name in the description | `string` | `"RDS Aurora SG managed by Terraform"` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | Map of security group rules to add to the cluster security group created | `any` | `{}` | no |
| <a name="input_serverlessv2_scaling_configuration"></a> [serverlessv2\_scaling\_configuration](#input\_serverlessv2\_scaling\_configuration) | Map of nested attributes with serverless v2 scaling properties. Only valid when engine\_mode is set to provisioned | `map(string)` | `{}` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final\_snapshot\_identifier | `bool` | `true` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | DB snapshot to create this database from | `string` | `""` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Allow Database encryption or not | `bool` | `true` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs used by database subnet group created | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | In which VPC do you want to deploy the RDS cluster | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_cluster_endpoint"></a> [rds\_cluster\_endpoint](#output\_rds\_cluster\_endpoint) | The endpoint URL of the Aurora cluster |
| <a name="output_rds_cluster_master_password"></a> [rds\_cluster\_master\_password](#output\_rds\_cluster\_master\_password) | The master password for the Aurora cluster |
| <a name="output_rds_cluster_master_username"></a> [rds\_cluster\_master\_username](#output\_rds\_cluster\_master\_username) | The master username for the Aurora cluster |
| <a name="output_rds_cluster_reader_endpoint"></a> [rds\_cluster\_reader\_endpoint](#output\_rds\_cluster\_reader\_endpoint) | The reader endpoint URL of the Aurora cluster |
| <a name="output_secondary_rds_cluster_endpoint"></a> [secondary\_rds\_cluster\_endpoint](#output\_secondary\_rds\_cluster\_endpoint) | The endpoint URL of the Aurora cluster secondary instance |
| <a name="output_secondary_rds_cluster_reader_endpoint"></a> [secondary\_rds\_cluster\_reader\_endpoint](#output\_secondary\_rds\_cluster\_reader\_endpoint) | A read-only endpoint for the cluster, automatically load-balanced across replicas |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The security group ID associated with the Aurora cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Contribute & Issue Report

To report an issue with a project:

  1. Check the repository's [issue tracker](https://github.com/sq-ia/terraform-aws-rds-aurora/issues) on GitHub
  2. Search to check if the issue has already been reported
  3. If you can't find an answer to your question in the documentation or issue tracker, you can ask a question by creating a new issue. Make sure to provide enough context and details.

## License

Apache License, Version 2.0, January 2004 (https://www.apache.org/licenses/LICENSE-2.0)

## Support Us

To support our GitHub project by liking it, you can follow these steps:

  1. Visit the repository: Navigate to the [GitHub repository](https://github.com/sq-ia/terraform-aws-rds-aurora)

  2. Click the "Star" button: On the repository page, you'll see a "Star" button in the upper right corner. Clicking on it will star the repository, indicating your support for the project.

  3. Optionally, you can also leave a comment on the repository or open an issue to give feedback or suggest changes.

Staring a repository on GitHub is a simple way to show your support and appreciation for the project. It also helps to increase the visibility of the project and make it more discoverable to others.

## Who we are

We believe that the key to success in the digital age is the ability to deliver value quickly and reliably. That’s why we offer a comprehensive range of DevOps & Cloud services designed to help your organization optimize its systems & Processes for speed and agility.

  1. We are an AWS Advanced consulting partner which reflects our deep expertise in AWS Cloud and helping 100+ clients over the last 5 years.
  2. Expertise in Kubernetes and overall container solution helps companies expedite their journey by 10X.
  3. Infrastructure Automation is a key component to the success of our Clients and our Expertise helps deliver the same in the shortest time.
  4. DevSecOps as a service to implement security within the overall DevOps process and helping companies deploy securely and at speed.
  5. Platform engineering which supports scalable,Cost efficient infrastructure that supports rapid development, testing, and deployment.
  6. 24*7 SRE service to help you Monitor the state of your infrastructure and eradicate any issue within the SLA.

We provide [support](https://squareops.com/contact-us/) on all of our projects, no matter how small or large they may be.

To find more information about our company, visit [squareops.com](https://squareops.com/), follow us on [Linkedin](https://www.linkedin.com/company/squareops-technologies-pvt-ltd/), or fill out a [job application](https://squareops.com/careers/). If you have any questions or would like assistance with your cloud strategy and implementation, please don't hesitate to [contact us](https://squareops.com/contact-us/).
