resource "aws_efs_file_system" "efs_volume" {
  creation_token = "${var.project}-efs"

  tags = merge(
    var.common_tags
  )
}

resource "aws_efs_mount_target" "this" {
  for_each = toset(var.mount_targets) 

  file_system_id  = aws_efs_file_system.efs_volume.id
  security_groups = var.security_groups
  subnet_id       = each.value
}