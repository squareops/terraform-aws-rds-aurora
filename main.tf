locals {
  tags = {
    Automation  = "true"
    Environment = var.environment
  }
  region           = var.region
  secondary_region = var.secondary_region
  role_arn            = var.role_arn
  assume_role_config  = length(var.role_arn) > 0 ? { role_arn = var.role_arn } : null
}

provider "aws" {
  region = local.region
  dynamic "assume_role" {
    for_each = local.assume_role_config != null ? [local.assume_role_config] : []
    content {
      role_arn = assume_role.value.role_arn
    }
  }
}

provider "aws" {
  alias  = "secondary"
  region = local.secondary_region
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "primary" {}
data "aws_availability_zones" "secondary" {
  provider = aws.secondary
}
data "aws_partition" "current" {
  depends_on = [data.aws_caller_identity.current]
}

module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "8.3.0"
  name    = format("%s-%s", var.environment, var.rds_instance_name)

  engine                 = var.engine
  engine_mode            = var.engine_mode
  engine_version         = var.engine_mode == "serverless" ? null : var.engine_version
  scaling_configuration  = var.engine_mode == "serverless" ? var.scaling_configuration : {}
  instance_class         = var.engine_mode == "serverless" ? null : var.instance_type
  storage_encrypted      = var.storage_encrypted
  kms_key_id             = var.kms_key_arn
  publicly_accessible    = var.publicly_accessible
  enable_http_endpoint   = var.enable_http_endpoint
  create_db_subnet_group = true

  instances                 = var.instances_config
  global_cluster_identifier = var.global_cluster_enable ? aws_rds_global_cluster.this[0].id : null

  database_name   = var.database_name
  master_username = var.master_username
  # create_random_password = var.create_random_password
  manage_master_user_password = var.manage_master_user_password ? true : false
  port                        = var.port

  create_security_group = var.create_security_group
  vpc_id                = var.vpc_id
  # cidr_blocks     = var.allowed_cidr_blocks
  # security_groups = var.allowed_security_groups
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = "${var.allowed_cidr_blocks}"
      # source_security_group_id = "${var.allowed_security_groups}"
    }
    egress_example = {
      cidr_blocks = ["0.0.0.0/0"]
      description = "Egress to Open World"
    }
  }
  subnets         = var.subnets
  master_password = var.manage_master_user_password ? null : random_password.master[0].result

  deletion_protection         = var.deletion_protection
  allow_major_version_upgrade = var.allow_major_version_upgrade
  skip_final_snapshot         = var.skip_final_snapshot
  # final_snapshot_identifier_prefix   = var.final_snapshot_identifier_prefix
  snapshot_identifier                = var.snapshot_identifier
  backup_retention_period            = var.backup_retention_period
  preferred_maintenance_window       = var.preferred_maintenance_window
  preferred_backup_window            = var.preferred_backup_window
  apply_immediately                  = var.apply_immediately
  db_parameter_group_name            = aws_db_parameter_group.rds_parameter_group.id
  db_cluster_parameter_group_name    = aws_rds_cluster_parameter_group.rds_cluster_parameter_group.id
  serverlessv2_scaling_configuration = var.serverlessv2_scaling_configuration
  autoscaling_enabled                = var.autoscaling_enabled
  autoscaling_max_capacity           = var.autoscaling_max
  autoscaling_min_capacity           = var.autoscaling_min
  autoscaling_target_cpu             = var.autoscaling_cpu
  autoscaling_target_connections     = var.autoscaling_target_connections
  autoscaling_scale_in_cooldown      = var.autoscaling_scale_in_cooldown
  autoscaling_scale_out_cooldown     = var.autoscaling_scale_out_cooldown
  predefined_metric_type             = var.predefined_metric_type

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled

  create_monitoring_role          = var.create_monitoring_role
  iam_role_name                   = format("%s-%s-%s", var.environment, var.rds_instance_name, "monitoring-role")
  monitoring_interval             = var.monitoring_interval
  security_group_description      = var.security_group_description
  enabled_cloudwatch_logs_exports = var.engine_mode == "provisioned" ? (var.engine == "aurora-mysql" ? ["audit", "error", "general", "slowquery"] : ["postgresql"]) : null
  tags = merge(
    { "Name" = format("%s-%s", var.environment, var.rds_instance_name) },
    local.tags,
  )
}

resource "aws_db_parameter_group" "rds_parameter_group" {
  name        = format("%s-%s-parameter-group", var.environment, var.rds_instance_name)
  family      = var.family
  description = "Terraform parameter group for ${var.family}"
  tags = merge(
    { "Name" = format("%s-%s-parameter-group", var.environment, var.rds_instance_name) },
    local.tags,
  )
  parameter {
    name  = (var.engine == "aurora-mysql" ? "slow_query_log" : "")
    value = (var.engine == "aurora-mysql" ? 1 : "")
  }
  parameter {
    name  = (var.engine == "aurora-mysql" ? "long_query_time" : "")
    value = (var.engine == "aurora-mysql" ? var.long_query_time : "")
  }
}
resource "aws_rds_cluster_parameter_group" "rds_cluster_parameter_group" {
  name        = format("%s-%s-cluster-parameter-group", var.environment, var.rds_instance_name)
  family      = var.family
  description = "Terraform cluster parameter group for ${var.family}"
  tags = merge(
    { "Name" = format("%s-%s-cluster-parameter-group", var.environment, var.rds_instance_name) },
    local.tags,
  )

  parameter {
    name  = (var.engine == "aurora-mysql" ? "require_secure_transport" : "rds.force_ssl")
    value = (var.engine == "aurora-mysql" ? (var.enable_ssl_connection ? "ON" : "OFF") : (var.engine == "aurora-postgres" && var.enable_ssl_connection ? 1 : 0))
  }
  parameter {
    name  = (var.engine == "aurora-mysql" ? "slow_query_log" : "")
    value = (var.engine == "aurora-mysql" ? 1 : "")
  }
  parameter {
    name  = (var.engine == "aurora-mysql" ? "long_query_time" : "")
    value = (var.engine == "aurora-mysql" ? var.long_query_time : "")
  }
}

resource "aws_secretsmanager_secret" "secret_master_db" {
  name = format("%s/%s/%s-%s", var.environment, var.rds_instance_name, var.engine, "aurora-pass")
  tags = merge(
    { "Name" = format("%s/%s/%s-%s", var.environment, var.rds_instance_name, var.engine, "aurora-pass") },
    local.tags,
  )
}

resource "random_password" "master" {
  count   = var.manage_master_user_password ? 0 : 1
  length  = var.random_password_length
  special = false
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  count         = var.manage_master_user_password ? 0 : 1
  secret_id     = aws_secretsmanager_secret.secret_master_db.id
  secret_string = <<EOF
{
  "username": "${module.aurora.cluster_master_username}",
  "password": "${random_password.master[0].result}",
  "engine": "${var.engine}",
  "host": "${module.aurora.cluster_endpoint}"
}
EOF
}

resource "aws_rds_global_cluster" "this" {
  count                     = var.global_cluster_enable ? 1 : 0
  global_cluster_identifier = format("%s-%s-%s", var.environment, var.rds_instance_name, "cluster")
  engine                    = var.engine
  engine_version            = var.engine_version
  database_name             = var.database_name
  storage_encrypted         = true
}

module "aurora_secondary" {
  source    = "terraform-aws-modules/rds-aurora/aws"
  count     = var.global_cluster_enable ? 1 : 0
  version   = "8.3.0"
  providers = { aws = aws.secondary }

  is_primary_cluster = false

  name                      = format("%s-%s-%s", var.environment, var.rds_instance_name, "secondary")
  engine                    = aws_rds_global_cluster.this[0].engine
  engine_version            = aws_rds_global_cluster.this[0].engine_version
  global_cluster_identifier = aws_rds_global_cluster.this[0].id
  source_region             = var.region
  instance_class            = var.instance_type
  instances                 = var.instances_config
  kms_key_id                = var.secondary_kms_key_arn
  subnets                   = var.secondary_subnets
  vpc_id                    = var.secondary_vpc_id
  create_db_subnet_group    = true
  security_group_rules = {
    vpc_ingress = {
      cidr_blocks = "${var.secondary_vpc_allowed_cidr_blocks}"
      # source_security_group_id = "${var.secondary_vpc_allowed_security_groups}"
    }
    egress_example = {
      cidr_blocks = ["0.0.0.0/0"]
      description = "Egress to Open World"
    }
  }

  # Global clusters do not support managed master user password
  master_password = random_password.master[0].result

  skip_final_snapshot = true

  depends_on = [
    module.aurora
  ]

  tags = merge(
    { "Name" = format("%s-%s-%s", var.environment, var.rds_instance_name, "secondary") },
    local.tags,
  )
}
