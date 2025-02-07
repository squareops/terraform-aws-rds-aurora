resource "kubernetes_namespace" "db" {
  count = var.create_namespace ? 1 : 0
  metadata {
    annotations = {}
    name        = var.namespace
  }
}

resource "helm_release" "db_backup" {
  count      = var.db_backup_enabled ? 1 : 0
  depends_on = [kubernetes_namespace.db]
  name       = "db-backup"
  chart      = "${path.module}/../../modules/db-backup-restore/backup"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("${path.module}/../../helm/values/backup/values.yaml", {
      bucket_uri                 = var.db_backup_config.bucket_uri,
      engine                     = var.engine,
      mysql_database_name        = var.bucket_provider_type == "s3" ? var.db_backup_config.mysql_database_name : "",
      db_endpoint                = var.bucket_provider_type == "s3" ? var.db_backup_config.db_endpoint : "",
      db_password                = var.bucket_provider_type == "s3" ? var.db_backup_config.db_password : "",
      db_username                = var.bucket_provider_type == "s3" ? var.db_backup_config.db_username : "",
      cron_for_full_backup       = var.db_backup_config.cron_for_full_backup,
      custom_user_username       = "admin",
      bucket_provider_type       = var.bucket_provider_type,
      azure_storage_account_name = var.bucket_provider_type == "azure" ? var.azure_storage_account_name : ""
      azure_storage_account_key  = var.bucket_provider_type == "azure" ? var.azure_storage_account_key : ""
      azure_container_name       = var.bucket_provider_type == "azure" ? var.azure_container_name : ""
      annotations                = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn: ${aws_iam_role.mysql_backup_role[count.index].arn}" : "iam.gke.io/gcp-service-account: ${var.service_account_backup}"
    })
  ]
}


## DB dump restore
resource "helm_release" "db_restore" {
  count      = var.db_restore_enabled ? 1 : 0
  depends_on = [kubernetes_namespace.db]
  name       = "db-restore"
  chart      = "${path.module}/../../modules/db-backup-restore/restore"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("${path.module}/../../helm/values/restore/values.yaml", {
      bucket_uri                 = var.db_restore_config.bucket_uri,
      file_name                  = var.db_restore_config.file_name,
      engine                     = var.engine,
      db_endpoint                = var.bucket_provider_type == "s3" ? var.db_restore_config.db_endpoint : "",
      db_password                = var.bucket_provider_type == "s3" ? var.db_restore_config.db_password : "",
      db_username                = var.bucket_provider_type == "s3" ? var.db_restore_config.db_username : "",
      custom_user_username       = "admin",
      bucket_provider_type       = var.bucket_provider_type,
      azure_storage_account_name = var.bucket_provider_type == "azure" ? var.azure_storage_account_name : ""
      azure_storage_account_key  = var.bucket_provider_type == "azure" ? var.azure_storage_account_key : ""
      azure_container_name       = var.bucket_provider_type == "azure" ? var.azure_container_name : ""
      annotations                = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn: ${aws_iam_role.mysql_restore_role[count.index].arn}" : "iam.gke.io/gcp-service-account: ${var.service_account_restore}"
    })
  ]
}
