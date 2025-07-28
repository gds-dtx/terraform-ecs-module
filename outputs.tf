output "efs_id" {
  value = var.efs_enabled ? aws_efs_file_system.shared[0].id : null
}

output "efs_sg_id" {
  value = var.efs_enabled ? aws_security_group.efs[0].id : null
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}
