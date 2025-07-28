resource "aws_efs_file_system" "shared" {
  count = var.efs_enabled ? 1 : 0

  creation_token = "${var.cluster_name}-efs"
  encrypted      = true
  kms_key_id     = aws_kms_key.efs[0].arn

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "${var.cluster_name}-efs"
  }
}

resource "aws_efs_mount_target" "this" {
  count = var.efs_enabled ? length(aws_subnet.private) : 0

  file_system_id = aws_efs_file_system.shared[0].id
  subnet_id      = aws_subnet.private[count.index].id
  security_groups = [
    aws_security_group.efs[0].id
  ]
}

resource "aws_efs_backup_policy" "this" {
  count = var.efs_enabled ? (var.efs_backup_enabled ? 1 : 0) : 0

  file_system_id = aws_efs_file_system.shared[0].id

  backup_policy {
    status = "ENABLED"
  }
}
