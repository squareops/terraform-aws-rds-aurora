## AURORA
![squareops_avatar]

[squareops_avatar]: https://squareops.com/wp-content/uploads/2022/12/squareops-logo.png

### [SquareOps Technologies](https://squareops.com/) Your DevOps Partner for Accelerating cloud journey.
<br>
We publish several terraform modules.
<br>
Terraform Module to create AWS Aurora(mysql/postgresql) on AWS Cloud.

## Usage Example
```hcl
module "aurora" {
  source = "gitlab.com/sq-ia/aws/rds-mysql.git"
  environment             = "production"
  rds_instance_name       = "skaf"
  create_security_group   = true
  allowed_cidr_blocks     = []
  allowed_security_groups = ["sg-xyzf8bdc01fd9skaf"]
  engine                  = "aurora-postgresql/aurora-mysql"
  engine_version          = "13.7"
  instance_type           = "db.r5.large"
  storage_encrypted       = true
  kms_key_arn             = "arn:aws:kms:us-east-2:222222222222:key/kms_key_arn"
  publicly_accessible     = false
  master_username         = "produser"
  database_name           = "proddb"
  port                    = 3306
  vpc_id                  = "vpc-xyz5ed733e273skaf"
  subnets                 = ["subnet-xyz546125e075skaf","subnet-xyz8f0564e655skaf"]
  apply_immediately       = true
  create_random_password  = true
  skip_final_snapshot              = true
  final_snapshot_identifier_prefix = "prod-snapshot"
  snapshot_identifier              = null
  preferred_maintenance_window     = "Mon:00:00-Mon:03:00"
  preferred_backup_window          = "03:00-06:00"
  backup_retention_period          = 7
  enable_ssl_connection            = false
  family = "aurora-postgresql13/aurora-mysql5.7"
  autoscaling_enabled              = true
  autoscaling_max                  = 4
  autoscaling_min                  = 1
  predefined_metric_type           = "RDSReaderAverageDatabaseConnections"
  autoscaling_target_connections   = 40
  autoscaling_scale_in_cooldown    = 60
  autoscaling_scale_out_cooldown   = 30
  deletion_protection              = false

}
```

## Important Notes
- Used to create RDS resource with AWS aurora engines.
- Contains the following features:
  1. Engine Mode for provisioned or serverless.
  2. Creation of a new security gorup with CIDR or Security group or both as ingress source.
  3. Engine version and Parameter Group configurations based on database engine.
  4. Generate a random master password.
  5. Number of replicas to create in cluster.
  6. Encrypted storage (with default or custom grenerated key)
  7. Maintainence slot and backup window for prod env.
  8. Option to skip final snapshot.
  9. Launch RDS in multiple subnets.
  10. Enable/Disable Deletion Protection.
  11. Creates a new parameter group and cluster parameter group.
  12. Cloudwatch monitoring and log export.
  13. Enable/Disable Apply Immediately for changes.
  14. SSL/TLS encryuption for connections.


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

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aurora"></a> [aurora](#module\_aurora) | terraform-aws-modules/rds-aurora/aws | 7.5.1 |

## Resources

| Name | Type |
|------|------|
| [aws_db_parameter_group.rds_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_rds_cluster_parameter_group.rds_cluster_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_parameter_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Determines whether major engine upgrades are allowed when changing engine version | `bool` | `false` | no |
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | A list of CIDR blocks which are allowed to access the database | `list(string)` | `[]` | no |
| <a name="input_allowed_security_groups"></a> [allowed\_security\_groups](#input\_allowed\_security\_groups) | A list of Security Group ID's to allow access to | `list(string)` | `[]` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Determines whether or not any DB modifications are applied immediately, or during the maintenance window | `bool` | `false` | no |
| <a name="input_autoscaling_cpu"></a> [autoscaling\_cpu](#input\_autoscaling\_cpu) | CPU usage to trigger autoscaling at | `number` | `70` | no |
| <a name="input_autoscaling_enabled"></a> [autoscaling\_enabled](#input\_autoscaling\_enabled) | Whether to enable autoscaling for RDS Aurora (MySQL) read replicas | `bool` | `false` | no |
| <a name="input_autoscaling_max"></a> [autoscaling\_max](#input\_autoscaling\_max) | Maximum number of replicas to allow scaling for | `number` | `3` | no |
| <a name="input_autoscaling_min"></a> [autoscaling\_min](#input\_autoscaling\_min) | Minimum number of replicas to allow scaling for | `number` | `1` | no |
| <a name="input_autoscaling_scale_in_cooldown"></a> [autoscaling\_scale\_in\_cooldown](#input\_autoscaling\_scale\_in\_cooldown) | Cooldown in seconds before allowing further scaling operations after a scale in | `number` | `300` | no |
| <a name="input_autoscaling_scale_out_cooldown"></a> [autoscaling\_scale\_out\_cooldown](#input\_autoscaling\_scale\_out\_cooldown) | Cooldown in seconds before allowing further scaling operations after a scale out | `number` | `300` | no |
| <a name="input_autoscaling_target_connections"></a> [autoscaling\_target\_connections](#input\_autoscaling\_target\_connections) | No of connections on which aurora has to scale if predefined\_metric\_type is RDSReaderAverageDatabaseConnections | `number` | `50` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | How long to keep backups for (in days) | `number` | `null` | no |
| <a name="input_create_monitoring_role"></a> [create\_monitoring\_role](#input\_create\_monitoring\_role) | Set it to true to create IAM role for Enhanced monitoring. | `bool` | `false` | no |
| <a name="input_create_random_password"></a> [create\_random\_password](#input\_create\_random\_password) | Whether to create random password for RDS primary cluster | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | create security group or not | `bool` | `true` | no |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name for an automatically created database on cluster creation | `string` | `""` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | provide accidental deletion protection | `bool` | `true` | no |
| <a name="input_enable_http_endpoint"></a> [enable\_http\_endpoint](#input\_enable\_http\_endpoint) | Whether or not to enable the Data API for a serverless Aurora database engine | `bool` | `false` | no |
| <a name="input_enable_ssl_connection"></a> [enable\_ssl\_connection](#input\_enable\_ssl\_connection) | Whether or not to enable the ssl connection | `bool` | `false` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | engine type | `string` | `"aurora"` | no |
| <a name="input_engine_mode"></a> [engine\_mode](#input\_engine\_mode) | The database engine mode. Valid values: global, parallelquery, provisioned, serverless, multimaster | `string` | `"provisioned"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | engine version | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Select enviroment type: dev, demo, prod | `string` | `"demo"` | no |
| <a name="input_family"></a> [family](#input\_family) | Version of aurora DB family being created | `string` | `"aurora-mysql5.7"` | no |
| <a name="input_final_snapshot_identifier_prefix"></a> [final\_snapshot\_identifier\_prefix](#input\_final\_snapshot\_identifier\_prefix) | The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too. | `string` | `"final"` | no |
| <a name="input_iam_database_authentication_enabled"></a> [iam\_database\_authentication\_enabled](#input\_iam\_database\_authentication\_enabled) | Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled | `bool` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type | `string` | `"db.m5.large"` | no |
| <a name="input_instances_config"></a> [instances\_config](#input\_instances\_config) | Map of cluster instances and any specific/overriding attributes to be created | `map(any)` | <pre>{<br>  "one": {}<br>}</pre> | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN.  If storage\_encrypted is set to true and kms\_key\_id is not specified the default KMS key created in your account will be used | `string` | `null` | no |
| <a name="input_master_username"></a> [master\_username](#input\_master\_username) | Master DB username | `string` | `"root"` | no |
| <a name="input_monitoring_interval"></a> [monitoring\_interval](#input\_monitoring\_interval) | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for instances. Set to 0 to disble. Default is 0 | `number` | `0` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights is enabled or not | `bool` | `null` | no |
| <a name="input_performance_insights_kms_key_id"></a> [performance\_insights\_kms\_key\_id](#input\_performance\_insights\_kms\_key\_id) | ARN of KMS key to encrypt performance insights data. | `string` | `null` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | Retention period for performance insights data, Either 7 (7 days) or 731 (2 years). | `number` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | port for database | `number` | `3306` | no |
| <a name="input_predefined_metric_type"></a> [predefined\_metric\_type](#input\_predefined\_metric\_type) | The metric type to scale on. Valid values are RDSReaderAverageCPUUtilization and RDSReaderAverageDatabaseConnections | `string` | `"RDSReaderAverageDatabaseConnections"` | no |
| <a name="input_preferred_backup_window"></a> [preferred\_backup\_window](#input\_preferred\_backup\_window) | When to perform DB backups | `string` | `""` | no |
| <a name="input_preferred_maintenance_window"></a> [preferred\_maintenance\_window](#input\_preferred\_maintenance\_window) | When to perform DB maintenance | `string` | `""` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Publicly accessible to the internet | `bool` | `false` | no |
| <a name="input_rds_instance_name"></a> [rds\_instance\_name](#input\_rds\_instance\_name) | RDS instance name | `string` | `"abc"` | no |
| <a name="input_scaling_configuration"></a> [scaling\_configuration](#input\_scaling\_configuration) | Map of nested attributes with scaling properties. Only valid when engine\_mode is set to `serverless` | `map(string)` | `{}` | no |
| <a name="input_security_group_description"></a> [security\_group\_description](#input\_security\_group\_description) | The description of the security group. If value is set to empty string it will contain cluster name in the description | `string` | `"RDS Aurora SG managed by Terraform"` | no |
| <a name="input_serverlessv2_scaling_configuration"></a> [serverlessv2\_scaling\_configuration](#input\_serverlessv2\_scaling\_configuration) | Map of nested attributes with serverless v2 scaling properties. Only valid when engine\_mode is set to provisioned | `map(string)` | `{}` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final\_snapshot\_identifier | `bool` | `true` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | DB snapshot to create this database from | `string` | `""` | no |
| <a name="input_storage_encrypted"></a> [storage\_encrypted](#input\_storage\_encrypted) | Allow Database encryption or not | `bool` | `true` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs used by database subnet group created | `list(string)` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | In which VPC do you want to deploy the RDS cluster | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_cluster_endpoint"></a> [rds\_cluster\_endpoint](#output\_rds\_cluster\_endpoint) | The cluster endpoint |
| <a name="output_rds_cluster_master_password"></a> [rds\_cluster\_master\_password](#output\_rds\_cluster\_master\_password) | The master password |
| <a name="output_rds_cluster_master_username"></a> [rds\_cluster\_master\_username](#output\_rds\_cluster\_master\_username) | The master username |
| <a name="output_rds_cluster_reader_endpoint"></a> [rds\_cluster\_reader\_endpoint](#output\_rds\_cluster\_reader\_endpoint) | The cluster reader endpoint |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The security group ID of the cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Contribute & Issue Report

To contribute to a project, you can typically:

  1. Find the repository on a platform like GitHub
  2. Fork the repository to your own account
  3. Make changes to the code
  4. Submit a pull request to the original repository

To report an issue with a project:

  1. Check the repository's [issue tracker](https://github.com/squareops/terraform-aws-vpc/issues) on GitHub
  2. Search to see if the issue has already been reported
  3. If you can't find an answer to your question in the documentation or issue tracker, you can ask a question by creating a new issue. Be sure to provide enough context and details so others can understand your problem.
  4. Contributing to the project can be a great way to get involved and get help. The maintainers and other contributors may be more likely to help you if you're already making contributions to the project.

## Our Other Projects

We have a number of other projects that you might be interested in:

  1. [terraform-aws-vpc](https://github.com/squareops/terraform-aws-vpc): Terraform module to create Networking resources for workload deployment on AWS Cloud.

  2. [terraform-aws-keypair](https://github.com/squareops/terraform-aws-keypair): Terraform module which creates EC2 key pair on AWS. The private key will be stored on SSM.

     Follow Us:

     To stay updated on our projects and future release, follow us on
     [GitHub](https://github.com/squareops/),
     [LinkedIn](https://www.linkedin.com/company/squareops-technologies-pvt-ltd/)

     By joining our both the [email](https://github.com/squareops) and [Slack community](https://github.com/squareops), you can benefit from the different ways in which we provide support. You can receive timely notifications and updates through email and engage in real-time conversations and discussions with other members through Slack. This combination of resources can help you stay informed, get help when you need it, and contribute to the project in a meaningful way.  

## Security, Validation and pull-requests

we have offered here excessive quality code and modules. Hence we are using several [pre-commit hooks](.pre-commit-config.yaml) and [GitHub Actions](https://gitlab.com/sq-ia/aws/eks/-/tree/v1.0.0#security-validation-and-pull-requests) as a workflow. So here we will create pull-requests to any branch and validate the request automatically using pre-commit tool.

## License

Apache License, Version 2.0, January 2004 (http://www.apache.org/licenses/).

## Support Us

To support a GitHub project by liking it, you can follow these steps:

  1. Visit the repository: Navigate to the GitHub repository that you want to support.

  2. Click the "Star" [button](https://github.com/squareops/terraform-aws-vpc): On the repository page, you'll see a "Star" button in the upper right corner. Clicking on it will star the repository, indicating your support for the project.

  3. Optionally, you can also leave a comment on the repository or open an issue to give feedback or suggest changes.

Staring a repository on GitHub is a simple way to show your support and appreciation for the project. It also helps to increase the visibility of the project and make it more discoverable to others.

## Who we are

We believe that the key to success in the digital age is the ability to deliver value quickly and reliably. That’s why we offer a comprehensive range of DevOps & Cloud services designed to help your organization optimize its systems & Processes for speed and agility.

  1. We are an AWS Advanced consulting partner which reflects our deep expertise in AWS Cloud and helping 100+ clients over the last 4 years.
  2. Expertise in Kubernetes and overall container solution helps companies expedite their journey by 10X.
  3. Infrastructure Automation is a key component to the success of our Clients and our Expertise helps deliver the same in the shortest time.
  4. DevSecOps as a service to implement security within the overall DevOps process and helping companies deploy securely and at speed.
  5. Platform engineering which supports scalable,Cost efficient infrastructure that supports rapid development, testing, and deployment.
  6. 24*7 SRE service to help you Monitor the state of your infrastructure and eradicate any issue within the SLA.

We provide [support](https://squareops.com/contact-us/) on all of our projects, no matter how small or large they may be.

You can find more information about our company on this [squareops.com](https://squareops.com/), follow us on [linkdin](https://www.linkedin.com/company/squareops-technologies-pvt-ltd/), or fill out a [job application](https://squareops.com/careers/). If you have any questions or would like assistance with your cloud strategy and implementation, please don't hesitate to [contact us](https://squareops.com/contact-us/).

