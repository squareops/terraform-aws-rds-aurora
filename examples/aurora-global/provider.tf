provider "aws" {
  region = local.region
}

provider "aws" {
  alias  = "secondary"
  region = local.secondary_region
}

# data "aws_caller_identity" "current" {}
data "aws_availability_zones" "primary" {}
data "aws_availability_zones" "secondary" {
  provider = aws.secondary
}