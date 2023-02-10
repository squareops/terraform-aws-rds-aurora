locals {
  environment       = "production"
  name              = "skaf"
  region            = "us-east-2"
  db_instance_class = "db.r5.large"
  db_engine_version = "13.7"
}

module "aurora" {
  source                           = "../../"
  environment                      = local.environment
  rds_instance_name                = local.name
  create_security_group            = true
  allowed_cidr_blocks              = []
  allowed_security_groups          = ["sg-xyzf8bdc01fd9skaf"]
  engine                           = "aurora-postgresql"
  engine_version                   = local.db_engine_version
  instance_type                    = local.db_instance_class
  storage_encrypted                = true
  kms_key_arn                      = "arn:aws:kms:us-east-2:222222222222:key/kms_key_arn"
  publicly_accessible              = false
  master_username                  = "devuser"
  database_name                    = "devdb"
  port                             = 3306
  vpc_id                           = "vpc-xyz5ed733e273skaf"
  subnets                          = ["subnet-xyz546125e075skaf", "subnet-xyz8f0564e655skaf"]
  apply_immediately                = true
  create_random_password           = true
  skip_final_snapshot              = true #  Keeping final snapshot results in retention of DB options group and hence creates problems during destroy. So use this option wisely.
  final_snapshot_identifier_prefix = "prod-snapshot"
  snapshot_identifier              = null
  preferred_maintenance_window     = "Mon:00:00-Mon:03:00"
  preferred_backup_window          = "03:00-06:00"
  backup_retention_period          = 7
  enable_ssl_connection            = false
  family                           = "aurora-postgresql13/mysql5.7"
  autoscaling_enabled              = true
  autoscaling_max                  = 4
  autoscaling_min                  = 1
  predefined_metric_type           = "RDSReaderAverageDatabaseConnections"
  autoscaling_target_connections   = 40
  autoscaling_scale_in_cooldown    = 60
  autoscaling_scale_out_cooldown   = 30
  deletion_protection              = false
}

