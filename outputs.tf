output "rds_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = module.aurora.cluster_endpoint
}

output "rds_cluster_reader_endpoint" {
  description = "The cluster reader endpoint"
  value       = module.aurora.cluster_reader_endpoint
}

output "rds_cluster_master_password" {
  description = "The master password"
  value       = nonsensitive(module.aurora.cluster_master_password)
}

output "rds_cluster_master_username" {
  description = "The master username"
  value       = nonsensitive(module.aurora.cluster_master_username)
}

# output "rds_cluster_instance_ids" {
#   description = "A list of all cluster instance ids"
#   value       = module.aurora.cluster_instances
# }

output "security_group_id" {
  description = "The security group ID of the cluster"
  value       = module.aurora.security_group_id
}
