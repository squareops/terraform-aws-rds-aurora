resource "kubernetes_namespace" "mysqldb" {
  count = var.create_namespace ? 1 : 0
  metadata {
    annotations = {}
    name        = var.namespace
  }
}

resource "helm_release" "mysqldb_backup" {
  count      = var.mysqldb_backup_enabled ? 1 : 0
  name       = "mysqldb-backup"
  chart      = "../../modules/db-backup-restore/backup"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("../../helm/values/backup/values.yaml", {
      bucket_uri                 = var.mysqldb_backup_config.bucket_uri,
      mysql_database_name        = var.mysqldb_backup_config.mysql_database_name,
      db_endpoint                = var.mysqldb_backup_config.db_endpoint,
      db_password                = var.mysqldb_backup_config.db_password ,
      db_username                = var.mysqldb_backup_config.db_username ,
      s3_bucket_region           = var.mysqldb_backup_config.s3_bucket_region ,
      cron_for_full_backup       = var.mysqldb_backup_config.cron_for_full_backup,
      annotations                = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn: ${aws_iam_role.mysql_backup_role.arn}" : "iam.gke.io/gcp-service-account: ${var.service_account_backup}"
     })
  ]
}


## DB dump restore
resource "helm_release" "mysqldb_restore" {
  count      = var.mysqldb_restore_enabled ? 1 : 0
  name       = "mysqldb-restore"
  chart      = "../../modules/db-backup-restore/restore"
  timeout    = 600
  namespace  = var.namespace
  values = [
    templatefile("../../helm/values/restore/values.yaml", {
      bucket_uri                 = var.mysqldb_restore_config.bucket_uri,
      db_endpoint                = var.mysqldb_restore_config.db_endpoint ,
      db_password                = var.mysqldb_restore_config.db_password,
      s3_bucket_region           = var.mysqldb_backup_config.s3_bucket_region ,
      db_username                = var.mysqldb_restore_config.db_username ,
      DB_NAME                    = var.mysqldb_restore_config.DB_NAME,
      backup_file_name           = var.mysqldb_restore_config.backup_file_name,
      annotations                = var.bucket_provider_type == "s3" ? "eks.amazonaws.com/role-arn: ${aws_iam_role.mysql_restore_role.arn}" : "iam.gke.io/gcp-service-account: ${var.service_account_restore}"
    })
  ]
}