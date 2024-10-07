provider "aws" {
  region = local.region
  dynamic "assume_role" {
  for_each = local.assume_role_config != null ? [1] : []
  content {
    role_arn = local.assume_role_config["role_arn"]
    }
  }
}
