data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "subnet_count" {
  description = "Number of public and private subnets to create"
  type        = number
  default     = 2
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "efs_enabled" {
  description = "Enable EFS file system"
  type        = bool
  default     = false
}

variable "efs_backup_enabled" {
  description = "Enable EFS backup policy"
  type        = bool
  default     = false
}

variable "container_insights" {
  description = "Enable container insights for the ECS cluster"
  type        = string
  default     = "disabled"
}
