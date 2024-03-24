
locals {
  engine = "aurora-mysql"
  engine_mode = "provisioned"
  cluster_id = "${var.env}-${var.project}-db-cluster"
}

##################
#Generate Password
##################

# # RDS Password
# Random Password
 resource "random_password" "rds_password" {
   length           = 16
   special          = false
 }

data "aws_caller_identity" "current" {}

 resource "aws_ssm_parameter" "rds_master_username" {
   name        = "${var.env}-${var.project}.db.admin.username"
   type        = "SecureString"
   value       = var.master_username
   description = "${var.env} ${var.project} RDS Master Username"
   tags = merge(
     var.common_tags
   )
 }

resource "aws_ssm_parameter" "rds_master_password" {
  name        = "${var.env}-${var.project}.db.admin.password"
  type        = "SecureString"
  value       = random_password.rds_password.result
  description = "${var.env} ${var.project} RDS Master Password"
  tags = merge(
    var.common_tags
  )
}

##########################################
# Aurora MySql Cluster
##########################################
resource "random_id" "uid" {
  byte_length = 8
}

resource "aws_rds_cluster" "pod_aurora" {
  cluster_identifier = local.cluster_id
  copy_tags_to_snapshot = var.copy_tags_to_snapshot
  deletion_protection = var.deletion_protection
  engine = local.engine
  engine_mode = local.engine_mode
  engine_version = var.engine_version
  master_username = aws_ssm_parameter.rds_master_username.value
  master_password = aws_ssm_parameter.rds_master_password.value
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  final_snapshot_identifier = "${local.cluster_id}-final-snapshot-${random_id.uid.hex}"
  skip_final_snapshot = var.skip_final_snapshot
  vpc_security_group_ids = var.vpc_security_group_ids
  enabled_cloudwatch_logs_exports = var.enabled_cw_logs_exports
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  port = var.port
  storage_encrypted = var.storage_encrypted
  apply_immediately = var.apply_immediately
  tags = var.common_tags
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count = var.instance_count
  engine = local.engine
  identifier = "${local.cluster_id}-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.pod_aurora.id
  instance_class = var.instance_type
  db_subnet_group_name = aws_db_subnet_group.subnet_group.name
  performance_insights_enabled = false
  preferred_maintenance_window = var.preferred_maintenance_window
  apply_immediately = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  tags = merge(
    var.common_tags
  )
}

data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id
  tags = {
    Tier = "Private"
  }
}

data "aws_subnet" "test_subnet" {
  count = "${length(data.aws_subnet_ids.private.ids)}"
  id    = "${tolist(data.aws_subnet_ids.private.ids)[count.index]}"
}

# RDS DB Subnet Group
resource "aws_db_subnet_group" "subnet_group" {
  name       = "${var.env}-${var.project}-subnet-group"
  subnet_ids = "${data.aws_subnet.test_subnet.*.id}"

  tags = merge(
    var.common_tags,
  )
}

resource "aws_ssm_parameter" "rds_url" {
   name        = "${var.env}-${var.project}.db.url"
   type        = "SecureString"
   value       = aws_rds_cluster.pod_aurora.endpoint
   description = "${var.env} ${var.project} RDS Endpoint"
   tags = merge(
     var.common_tags
   )
 }