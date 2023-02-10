locals {
  tags = {
    Automation  = "true"
    Environment = var.environment
  }
}


module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.5.1"
  name    = format("%s-%s", var.environment, var.rds_instance_name)

  engine                = var.engine
  engine_mode           = var.engine_mode
  engine_version        = var.engine_mode == "serverless" ? null : var.engine_version
  scaling_configuration = var.engine_mode == "serverless" ? var.scaling_configuration : {}
  instance_class        = var.engine_mode == "serverless" ? null : var.instance_type
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.kms_key_arn
  publicly_accessible   = var.publicly_accessible
  enable_http_endpoint  = var.enable_http_endpoint

  instances = var.instances_config

  database_name          = var.database_name
  master_username        = var.master_username
  create_random_password = var.create_random_password
  port                   = var.port

  create_security_group   = var.create_security_group
  vpc_id                  = var.vpc_id
  allowed_cidr_blocks     = var.allowed_cidr_blocks
  allowed_security_groups = var.allowed_security_groups
  subnets                 = var.subnets

  deletion_protection                = var.deletion_protection
  allow_major_version_upgrade        = var.allow_major_version_upgrade
  skip_final_snapshot                = var.skip_final_snapshot
  final_snapshot_identifier_prefix   = var.final_snapshot_identifier_prefix
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

}
