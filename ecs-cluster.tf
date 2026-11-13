resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = var.container_insights
  }

  configuration {
    managed_storage_configuration {
      fargate_ephemeral_storage_kms_key_id = aws_kms_key.fargate_storage.arn
    }
  }

  tags = {
    Name = var.cluster_name
  }
}

resource "aws_lb" "this" {
  name                       = "${var.cluster_name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = aws_subnet.public[*].id
  security_groups            = [aws_security_group.alb.id]
  drop_invalid_header_fields = var.drop_invalid_headers

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.id
    enabled = true
    prefix  = "${var.cluster_name}/alb-logs"
  }

  tags = {
    Name = "${var.cluster_name}-alb"
  }
}
