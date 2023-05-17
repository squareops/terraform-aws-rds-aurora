locals {
  environment             = "production"
  name                    = "skaf"
  region                  = "us-east-2"
  port                    = 5432 / 3306
  family                  = "aurora-postgresql15/aurora-mysql5.7"
  engine                  = "aurora-postgresql/aurora-mysql"
  vpc_id                  = "vpc-00ae5511ee10671c1"
  subnets                 = ["subnet-0d9a81939c6dd2a6e", "subnet-0fd26f0d73dc9e73d"]
  kms_key_arn             = "arn:aws:kms:us-east-2:271251951598:key/73ff9e84-83e1-4097-b388-fe29623338a9"
  db_engine_version       = "15.2/5.7"
  db_instance_class       = "db.r5.large"
  allowed_security_groups = ["sg-0a680184e11eafd35"]
}

module "aurora" {
  source                           = "git@github.com:sq-ia/terraform-aws-rds-aurora.git"
  environment                      = local.environment
  port                             = local.port
  vpc_id                           = local.vpc_id
  family                           = local.family
  subnets                          = local.subnets
  engine                           = local.engine
  engine_version                   = local.db_engine_version
  rds_instance_name                = local.name
  create_security_group            = true
  allowed_security_groups          = local.allowed_security_groups
  instance_type                    = local.db_instance_class
  storage_encrypted                = true
  kms_key_arn                      = local.kms_key_arn
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
  deletion_protection              = false
  predefined_metric_type           = "RDSReaderAverageDatabaseConnections"
  autoscaling_target_connections   = 40
  autoscaling_scale_in_cooldown    = 60
  autoscaling_scale_out_cooldown   = 30
}
