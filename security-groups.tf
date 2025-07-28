### --- Security Group for ALB ---
# This security group allows inbound HTTP traffic on ports 8000 to 16000

resource "aws_security_group" "alb" {
  name        = "${var.cluster_name}-alb-sg"
  description = "Allow HTTP and HTTPS inbound"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTP"
    from_port   = 8000
    to_port     = 16000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-alb-sg"
  }
}

### --- Security Group for EFS ---
# This security group allows inbound NFS traffic on port 2049 from private subnets
# It is used by ECS tasks to access the EFS file system.

resource "aws_security_group" "efs" {
  count = var.efs_enabled ? 1 : 0

  name        = "${var.cluster_name}-efs-sg"
  description = "Allow ECS tasks to access EFS"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    # allow access from any private subnet in the VPC
    cidr_blocks = aws_subnet.private[*].cidr_block
  }

  tags = {
    Name = "${var.cluster_name}-efs-sg"
  }
}
