provider "aws" {
  region = local.region
  dynamic "assume_role" {
    for_each = local.assume_role_config != null ? [1] : []
    content {
      role_arn = local.assume_role_config["role_arn"]
      # Conditionally add external_id if role_arn is provided
      external_id = local.role_arn != "" ? local.external_id : null
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_name

}
data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
