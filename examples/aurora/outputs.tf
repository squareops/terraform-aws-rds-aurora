output "aurora_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = module.aurora.rds_cluster_endpoint
}

output "aurora_cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = module.aurora.rds_cluster_reader_endpoint
}

output "aurora_cluster_master_password" {
  description = "The master password"
  value       = module.aurora.rds_cluster_master_password
}

output "aurora_cluster_master_username" {
  description = "The master username"
  value       = module.aurora.rds_cluster_master_username
}

output "aurora_security_group_id" {
  description = "The security group ID of the cluster"
  value       = module.aurora.security_group_id
}
