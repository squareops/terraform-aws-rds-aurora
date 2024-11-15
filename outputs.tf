output "rds_cluster_endpoint" {
  description = "The endpoint URL of the Aurora cluster"
  value       = module.aurora.cluster_endpoint
}

output "rds_cluster_reader_endpoint" {
  description = "The reader endpoint URL of the Aurora cluster"
  value       = module.aurora.cluster_reader_endpoint
}

output "secondary_rds_cluster_endpoint" {
  description = "The endpoint URL of the Aurora cluster secondary instance"
  value       = var.global_cluster_enable ? module.aurora_secondary[0].cluster_endpoint : null
}

output "secondary_rds_cluster_reader_endpoint" {
  description = "A read-only endpoint for the cluster, automatically load-balanced across replicas"
  value       = var.global_cluster_enable ? module.aurora_secondary[0].cluster_reader_endpoint : null
}

output "rds_cluster_database_name"{
  description = "Name for an automatically created database on cluster creation"
  value       = module.aurora.cluster_database_name
}

output "rds_cluster_master_password" {
  description = "The master password for the Aurora cluster"
  value       = nonsensitive(module.aurora.cluster_master_password)
}

output "rds_cluster_master_username" {
  description = "The master username for the Aurora cluster"
  value       = nonsensitive(module.aurora.cluster_master_username)
}

output "security_group_id" {
  description = "The security group ID associated with the Aurora cluster"
  value       = module.aurora.security_group_id
}
