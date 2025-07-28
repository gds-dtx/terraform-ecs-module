# Terraform ECS Module

The purpose of this module is to create an ECS cluster with some sensible defaults for use in Digital Backbone.
The aim is to simplify creating multiple instances of the same application.

## Features

- Creates an ECS cluster
- Integrates with AWS IAM for role management
- Enables CloudWatch logging
- Creates a VPC with subnets and security groups
- Creates a load balancer for the services
- Logs ALB access logs to S3
- Supports EFS
- Outputs variables for integration with other modules

## Usage

To use this module, include it in your Terraform configuration:

```hcl
module "ecs" {
    source             = "github.com/govuk-digital-backbone/terraform-ecs-module"
    cluster_name       = "my-cluster"
    efs_enabled        = false
    efs_backup_enabled = false
    container_insights = false
}
```

## Where this module is used

- [Planka Infrastructure as Code Module](https://github.com/govuk-digital-backbone/planka-iac)
  - Open source project tracking as Kanban boards
