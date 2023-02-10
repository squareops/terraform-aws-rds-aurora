variable "allowed_cidr_blocks" {
  description = "A list of CIDR blocks which are allowed to access the database"
  type        = list(string)
  default     = []
}

variable "allow_major_version_upgrade" {
  description = "Determines whether major engine upgrades are allowed when changing engine version"
  type        = bool
  default     = false
}

variable "allowed_security_groups" {
  description = "A list of Security Group ID's to allow access to"
  type        = list(string)
  default     = []
}

variable "apply_immediately" {
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = null
}

variable "create_random_password" {
  description = "Whether to create random password for RDS primary cluster"
  type        = bool
  default     = true
}

variable "create_security_group" {
  description = "create security group or not"
  type        = bool
  default     = true
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = ""
}

variable "deletion_protection" {
  description = "provide accidental deletion protection"
  default     = true
  type        = bool
}

variable "engine" {
  description = "engine type"
  default     = "aurora"
  type        = string
}

variable "enable_http_endpoint" {
  description = "Whether or not to enable the Data API for a serverless Aurora database engine"
  type        = bool
  default     = false
}

variable "enable_ssl_connection" {
  description = "Whether or not to enable the ssl connection"
  default     = false
  type        = bool
}

variable "engine_mode" {
  description = "The database engine mode. Valid values: global, parallelquery, provisioned, serverless, multimaster"
  type        = string
  default     = "provisioned"
}

variable "engine_version" {
  description = "engine version"
  default     = ""
  type        = string
}

variable "environment" {
  description = "Select enviroment type: dev, demo, prod"
  default     = "demo"
  type        = string
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
  default     = "db.m5.large"
  type        = string
}

variable "kms_key_arn" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN.  If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used"
  type        = string
  default     = null
}

variable "master_username" {
  description = "Master DB username"
  type        = string
  default     = "root"
}

variable "port" {
  description = "port for database"
  type        = number
  default     = 3306
}

variable "preferred_backup_window" {
  description = "When to perform DB backups"
  type        = string
  default     = ""
}

variable "preferred_maintenance_window" {
  description = "When to perform DB maintenance"
  type        = string
  default     = ""
}

variable "publicly_accessible" {
  description = "Publicly accessible to the internet"
  default     = false
  type        = bool
}

variable "rds_instance_name" {
  description = "RDS instance name"
  default     = "abc"
  type        = string
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
  default     = true
  type        = bool
}

variable "subnets" {
  description = "List of subnet IDs used by database subnet group created"
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
  type        = map(any)
  description = "Map of cluster instances and any specific/overriding attributes to be created"
  default = {
    one = {}
  }
}

variable "create_monitoring_role" {
  type        = bool
  default     = false
  description = "Set it to true to create IAM role for Enhanced monitoring."
}

variable "serverlessv2_scaling_configuration" {
  type        = map(string)
  default     = {}
  description = "Map of nested attributes with serverless v2 scaling properties. Only valid when engine_mode is set to provisioned"
}

variable "performance_insights_retention_period" {
  type        = number
  default     = null
  description = "Retention period for performance insights data, Either 7 (7 days) or 731 (2 years)."
}

variable "performance_insights_kms_key_id" {
  type        = string
  default     = null
  description = "ARN of KMS key to encrypt performance insights data."
}

variable "performance_insights_enabled" {
  type        = bool
  default     = null
  description = "Specifies whether Performance Insights is enabled or not"
}

variable "iam_database_authentication_enabled" {
  type        = bool
  default     = null
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
}

variable "autoscaling_target_connections" {
  type        = number
  default     = 50
  description = "No of connections on which aurora has to scale if predefined_metric_type is RDSReaderAverageDatabaseConnections"
}

variable "monitoring_interval" {
  type        = number
  default     = 0
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for instances. Set to 0 to disble. Default is 0"
}

variable "predefined_metric_type" {
  type        = string
  description = "The metric type to scale on. Valid values are RDSReaderAverageCPUUtilization and RDSReaderAverageDatabaseConnections"
  default     = "RDSReaderAverageDatabaseConnections"
}
