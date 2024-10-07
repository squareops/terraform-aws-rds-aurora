variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = any
  default     = []
}

variable "allow_major_version_upgrade" {
  description = "Determines whether major engine upgrades are allowed when changing engine version"
  type        = bool
  default     = false
}

variable "allowed_security_groups" {
  description = "A list of Security Group IDs to allow access to the database"
  type        = any
  default     = []
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately or during the next maintenance window"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The number of days to retain backups for"
  type        = number
  default     = null
}

variable "create_random_password" {
  description = "Whether to create a random password for the primary database cluster"
  type        = bool
  default     = true
}

variable "create_security_group" {
  description = "Whether to create a security group or not"
  type        = bool
  default     = true
}

variable "database_name" {
  description = "The name for an automatically created database on cluster creation"
  type        = string
  default     = ""
}

variable "deletion_protection" {
  description = "Whether accidental deletion protection is enabled"
  type        = bool
  default     = true
}

variable "engine" {
  description = "The name of the database engine to be used for this DB cluster"
  type        = string
  default     = "aurora"
}

variable "enable_http_endpoint" {
  description = "Whether or not to enable the Data API for a serverless Aurora database engine"
  type        = bool
  default     = false
}

variable "enable_ssl_connection" {
  description = "Whether or not to enable the ssl connection"
  type        = bool
  default     = false
}

variable "engine_mode" {
  description = "The database engine mode. Valid values: global, parallelquery, provisioned, serverless, multimaster"
  type        = string
  default     = "provisioned"
}

variable "engine_version" {
  description = "The database engine version. Updating this argument results in an outage."
  type        = string
  default     = ""
}

variable "environment" {
  description = "Select enviroment type: dev, demo, prod"
  type        = string
  default     = "demo"
}

variable "family" {
  description = "Version of aurora DB family being created"
  type        = string
  default     = "aurora-mysql5.7"
}

variable "final_snapshot_identifier_prefix" {
  description = "The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too."
  type        = string
  default     = "final"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "db.m5.large"
}

variable "kms_key_arn" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN.  If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used"
  type        = string
  default     = null
}

variable "master_username" {
  description = "The username for the primary cluster"
  type        = string
  default     = "root"
}

variable "port" {
  description = "The port for the database"
  type        = number
  default     = 3306
}

variable "preferred_backup_window" {
  description = "The maintenance window for performing database backup"
  type        = string
  default     = ""
}

variable "preferred_maintenance_window" {
  description = "The maintenance window for performing database maintenance"
  type        = string
  default     = ""
}

variable "publicly_accessible" {
  description = "Specifies whether the database is publicly accessible over the internet"
  type        = bool
  default     = false
}

variable "rds_instance_name" {
  description = "The name of the RDS instance"
  type        = string
  default     = ""
}

variable "scaling_configuration" {
  description = "Map of nested attributes with scaling properties. Only valid when engine_mode is set to `serverless`"
  type        = map(string)
  default     = {}
}

variable "security_group_description" {
  description = "The description of the security group. If value is set to empty string it will contain cluster name in the description"
  type        = string
  default     = "RDS Aurora SG managed by Terraform"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = true
}

variable "storage_encrypted" {
  description = "Allow Database encryption or not"
  type        = bool
  default     = true
}

variable "subnets" {
  description = "List of subnet IDs used by database subnet group created"
  type        = list(string)
  default     = []
}

variable "secondary_subnets" {
  description = "List of subnet IDs used by database subnet group created in secondary region"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "In which VPC do you want to deploy the RDS cluster"
  type        = string
  default     = ""
}

variable "autoscaling_enabled" {
  description = "Whether to enable autoscaling for RDS Aurora (MySQL) read replicas"
  type        = bool
  default     = false
}

variable "autoscaling_max" {
  description = "Maximum number of replicas to allow scaling for"
  type        = number
  default     = 3
}

variable "autoscaling_min" {
  description = "Minimum number of replicas to allow scaling for"
  type        = number
  default     = 1
}

variable "autoscaling_cpu" {
  description = "CPU usage to trigger autoscaling at"
  type        = number
  default     = 70
}

variable "autoscaling_scale_in_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale in"
  type        = number
  default     = 300
}

variable "autoscaling_scale_out_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale out"
  type        = number
  default     = 300
}

variable "snapshot_identifier" {
  description = "DB snapshot to create this database from"
  type        = string
  default     = ""
}

variable "instances_config" {
  description = "Map of cluster instances and any specific/overriding attributes to be created"
  type        = map(any)
  default = {
    one = {}
  }
}

variable "create_monitoring_role" {
  description = "Set it to true to create IAM role for Enhanced monitoring."
  type        = bool
  default     = false
}

variable "serverlessv2_scaling_configuration" {
  description = "Map of nested attributes with serverless v2 scaling properties. Only valid when engine_mode is set to provisioned"
  type        = map(string)
  default     = {}
}

variable "performance_insights_retention_period" {
  description = "Retention period for performance insights data, Either 7 (7 days) or 731 (2 years)."
  type        = number
  default     = null
}

variable "performance_insights_kms_key_id" {
  description = "ARN of KMS key to encrypt performance insights data."
  type        = string
  default     = null
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights is enabled or not"
  type        = bool
  default     = null
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  type        = bool
  default     = null
}

variable "autoscaling_target_connections" {
  description = "No of connections on which aurora has to scale if predefined_metric_type is RDSReaderAverageDatabaseConnections"
  type        = number
  default     = 50
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for instances. Set to 0 to disble. Default is 0"
  type        = number
  default     = 0
}

variable "predefined_metric_type" {
  description = "The metric type to scale on. Valid values are RDSReaderAverageCPUUtilization and RDSReaderAverageDatabaseConnections"
  type        = string
  default     = "RDSReaderAverageDatabaseConnections"
}

variable "long_query_time" {
  description = "To prevent fast-running queries from being logged in the slow query log, specify a value for the shortest query runtime to be logged, in seconds"
  type        = number
  default     = 10
}

variable "manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager. Cannot be set if `master_password` is provided"
  type        = bool
  default     = false
}

variable "random_password_length" {
  description = "The length of the randomly generated password. (default: 10)"
  type        = number
  default     = 16
}

variable "enable_egress" {
  description = "Set it true if allow outbound traffic in rds security group"
  type        = bool
  default     = true
}

variable "security_group_rules" {
  description = "Map of security group rules to add to the cluster security group created"
  type        = any
  default     = {}
}

variable "global_cluster_enable" {
  description = "Whether enable global cluster then set it to true"
  type        = bool
  default     = false
}

variable "secondary_kms_key_arn" {
  description = "The ARN for the secondary region KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN.  If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used"
  type        = string
  default     = null
}

variable "secondary_vpc_id" {
  description = "The secondary VPC in which secondary RDS will be launched"
  type        = string
  default     = ""
}

variable "secondary_vpc_allowed_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = any
  default     = []
}

variable "secondary_vpc_allowed_security_groups" {
  description = "A list of Security Group IDs to allow access to the database"
  type        = any
  default     = []
}

variable "region" {
  description = "AWS region name where the primary RDS resources will be deployed"
  default     = null
  type        = string
}

variable "secondary_region" {
  description = "Secondary AWS region name where the Secondary RDS and VPC resources will be deployed"
  default     = null
  type        = string
}

variable "global_cluster_identifier" {
  description = "Global RDS Cluster Identifier name"
  default     = null
  type        = string
}

variable "role_arn" {
  description = "The ARN of the role to assume. Leave empty if not using assume role."
  type        = string
  default     = "" # Default to empty string if not provided
}

variable "assume_role_arn" {
  description = "Optional ARN for assuming a role."
  type        = string
  default     = "" # Default to empty string if not provided
}
