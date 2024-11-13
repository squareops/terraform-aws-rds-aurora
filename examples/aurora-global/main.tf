
locals {
  name              = "skaf"
  region            = "ap-south-1"
  port              = 5432                  #/ 3306
  family            = "aurora-postgresql15" #/aurora-mysql5.7"
  engine            = "aurora-postgresql"   #/aurora-mysql"
  vpc_cidr          = "10.0.0.0/16"
  environment       = "production"
  db_engine_version = "15.2" #/5.7"
  db_instance_class = "db.r5.large"
  additional_aws_tags = {
    Owner      = "Organization_Name"
    Expires    = "Never"
    Department = "Engineering"
  }
  current_identity                      = data.aws_caller_identity.current.arn
  secondary_vpc_cidr                    = "10.10.0.0/16"
  allowed_security_groups               = ["sg-0ef14212995d67a2d"]
  secondary_vpc_allowed_security_groups = ["sg-0ef14212995d67a2d"]
  secondary_vpc_allowed_cidr_blocks     = ["10.0.0.0/16"]
  allowed_cidr_blocks                   = ["10.10.0.0/16"]
  global_cluster_enable                 = true
  secondary_region                      = "us-west-2"
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
  multi_region            = true

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
  availability_zones      = ["ap-south-1a", "ap-south-1b"]
  public_subnet_enabled   = true
  auto_assign_public_ip   = true
  intra_subnet_enabled    = false
  private_subnet_enabled  = true
  one_nat_gateway_per_az  = false
  database_subnet_enabled = true
}


module "secondary_vpc" {
  source                  = "squareops/vpc/aws"
  name                    = format("%s-%s", local.name, "secondary")
  providers               = { aws = aws.secondary }
  vpc_cidr                = local.secondary_vpc_cidr
  environment             = local.environment
  availability_zones      = slice(data.aws_availability_zones.secondary.names, 0, 3)
  public_subnet_enabled   = true
  auto_assign_public_ip   = true
  intra_subnet_enabled    = false
  private_subnet_enabled  = true
  one_nat_gateway_per_az  = false
  database_subnet_enabled = true
}


module "aurora" {
  source                                = "squareops/rds-aurora/aws"
  version                               = "2.1.1"
  environment                           = local.environment
  global_cluster_enable                 = true
  port                                  = local.port
  vpc_id                                = module.vpc.vpc_id
  family                                = local.family
  subnets                               = module.vpc.database_subnets
  engine                                = local.engine
  engine_version                        = local.db_engine_version
  rds_instance_name                     = local.name
  create_security_group                 = true
  instance_type                         = local.db_instance_class
  storage_encrypted                     = true
  kms_key_arn                           = module.kms.key_arn
  publicly_accessible                   = false
  master_username                       = "devuser"
  database_name                         = "devdb"
  apply_immediately                     = true
  create_random_password                = true
  skip_final_snapshot                   = true #  Keeping final snapshot results in retention of DB options group and hence creates problems during destroy. So use this option wisely.
  snapshot_identifier                   = null
  preferred_backup_window               = "03:00-06:00"
  preferred_maintenance_window          = "Mon:00:00-Mon:03:00"
  final_snapshot_identifier_prefix      = "prod-snapshot"
  backup_retention_period               = 7
  enable_ssl_connection                 = false
  autoscaling_enabled                   = true
  autoscaling_max                       = 4
  autoscaling_min                       = 1
  long_query_time                       = 10
  deletion_protection                   = false
  predefined_metric_type                = "RDSReaderAverageDatabaseConnections"
  autoscaling_target_connections        = 40
  autoscaling_scale_in_cooldown         = 60
  autoscaling_scale_out_cooldown        = 30
  allowed_cidr_blocks                   = local.allowed_cidr_blocks
  allowed_security_groups               = local.allowed_security_groups
  secondary_vpc_allowed_security_groups = local.secondary_vpc_allowed_security_groups
  secondary_vpc_allowed_cidr_blocks     = local.secondary_vpc_allowed_cidr_blocks
  secondary_vpc_id                      = module.secondary_vpc.vpc_id
  secondary_kms_key_arn                 = module.kms.key_arn
  secondary_subnets                     = module.secondary_vpc.database_subnets
}
