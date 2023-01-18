provider "aws" {
  region = local.region
}

locals {
  region      = "us-east-1"
  environment = "prod123"
  name        = "skaf"
}

module "aurora" {
  source = "../../"

  rds_instance_name     = local.name
  region                = local.region
  environment           = local.environment
  engine                = "aurora-mysql"
  engine_version        = "5.7.12"
  instance_type         = "db.t3.medium"
  vpc_id                = module.vpc.vpc_id
  subnets               = module.vpc.public_subnets
  master_username       = "exampleuser"
  database_name         = "exampledb"
  create_security_group = true
  allowed_cidr_blocks   = []
}
