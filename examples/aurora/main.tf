
locals {
  role_arn           = "" # Pass role arn of another aws account in which you want to create RDS, make sure to add required policies in role.
  external_id        = "" # Define your external ID here
  assume_role_config = length(local.role_arn) > 0 ? { role_arn = local.role_arn } : null
  name               = "skaf"
  region             = "us-east-2"
  port               = 5432                  #/3306
  family             = "aurora-postgresql15" #/aurora-mysql5.7"
  engine             = "aurora-postgresql"   #/aurora-mysql"
  vpc_cidr           = "10.0.0.0/16"
  environment        = "production"
  db_engine_version  = "15.2" #/5.7"
  db_instance_class  = "db.r5.large"
  master_password   = ""  # Leave this field empty to have a password automatically generated.
  additional_aws_tags = {
    Owner      = "Organization_Name"
    Expires    = "Never"
    Department = "Engineering"
  }
  current_identity        = data.aws_caller_identity.current.arn
  allowed_cidr_blocks     = ["10.10.0.0/16"]
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "kms" {
  source = "terraform-aws-modules/kms/aws"

  deletion_window_in_days = 7
  description             = "Complete key example showing various configurations available"
  enable_key_rotation     = false
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  multi_region            = false

  # Policy
  enable_default_policy = true
  key_owners            = [local.current_identity]
  key_administrators    = [local.current_identity]
  key_users             = [local.current_identity]
  key_service_users     = [local.current_identity]
  key_statements = [
    {
      sid = "CloudWatchLogs"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]

      principals = [
        {
          type        = "AWS"
          identifiers = ["*"]
        }
      ]
    }
  ]

  # Aliases
  aliases = ["${local.name}"]

  tags = local.additional_aws_tags
}

module "vpc" {
  source                  = "squareops/vpc/aws"
  name                    = local.name
  vpc_cidr                = local.vpc_cidr
  environment             = local.environment
  availability_zones      = ["us-east-2a", "us-east-2b"]
  public_subnet_enabled   = true
  auto_assign_public_ip   = true
  intra_subnet_enabled    = false
  private_subnet_enabled  = true
  one_nat_gateway_per_az  = false
  database_subnet_enabled = true
}



module "aurora" {
  source                           = "squareops/rds-aurora/aws"
  version                          = "2.2.0"
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
  master_password                  = local.master_password
  apply_immediately                = true
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
}
