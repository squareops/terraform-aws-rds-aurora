provider "aws" {
  region = local.region
    default_tags {
    tags = local.additional_aws_tags
  }
}

data "aws_eks_cluster" "cluster" {
  name = "test-atmosly-task-ipv4"

}
data "aws_eks_cluster_auth" "cluster" {
  name = "test-atmosly-task-ipv4"
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
