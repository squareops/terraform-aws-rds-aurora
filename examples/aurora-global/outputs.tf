output "aurora_cluster_endpoint" {
  description = "The endpoint URL of the Aurora cluster"
  value       = module.aurora.rds_cluster_endpoint
}

output "aurora_cluster_reader_endpoint" {
  description = "The reader endpoint URL of the Aurora cluster"
  value       = module.aurora.rds_cluster_reader_endpoint
}

output "aurora_cluster_master_password" {
  description = "The master password for the Aurora cluster"
  value       = module.aurora.rds_cluster_master_password
}

output "aurora_cluster_master_username" {
  description = "The master username for the Aurora cluster"
  value       = module.aurora.rds_cluster_master_username
}

output "aurora_security_group_id" {
  description = "The security group ID associated with the Aurora cluster"
  value       = module.aurora.security_group_id
}
