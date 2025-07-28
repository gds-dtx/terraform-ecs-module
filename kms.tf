### --- EFS KMS Key Configuration ---
# This configuration creates a KMS key for encrypting EFS file systems.

resource "aws_kms_key" "efs" {
  count                   = var.efs_enabled ? 1 : 0
  description             = "${var.cluster_name}: EFS KMS Key"
  deletion_window_in_days = 7
}

### --- Fargate Ephemeral Storage KMS Key Configuration ---
# This configuration creates a KMS key for encrypting Fargate ephemeral storage.

resource "aws_kms_key" "fargate_storage" {
  description             = "${var.cluster_name}: Fargate Ephemeral Storage KMS Key"
  deletion_window_in_days = 7
}

resource "aws_kms_key_policy" "fargate_storage" {
  key_id = aws_kms_key.fargate_storage.id
  policy = jsonencode({
    Id = "ECSClusterFargatePolicy"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          "AWS" : "*"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow generate data key access for Fargate tasks."
        Effect = "Allow"
        Principal = {
          Service = "fargate.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKeyWithoutPlaintext"
        ]
        Condition = {
          StringEquals = {
            "kms:EncryptionContext:aws:ecs:clusterAccount" = [
              data.aws_caller_identity.current.account_id
            ]
            "kms:EncryptionContext:aws:ecs:clusterName" = [
              var.cluster_name
            ]
          }
        }
        Resource = "*"
      },
      {
        Sid    = "Allow grant creation permission for Fargate tasks."
        Effect = "Allow"
        Principal = {
          Service = "fargate.amazonaws.com"
        }
        Action = [
          "kms:CreateGrant"
        ]
        Condition = {
          StringEquals = {
            "kms:EncryptionContext:aws:ecs:clusterAccount" = [
              data.aws_caller_identity.current.account_id
            ]
            "kms:EncryptionContext:aws:ecs:clusterName" = [
              var.cluster_name
            ]
          }
          "ForAllValues:StringEquals" = {
            "kms:GrantOperations" = [
              "Decrypt"
            ]
          }
        }
        Resource = "*"
      }
    ]
    Version = "2012-10-17"
  })
}
