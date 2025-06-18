# KMS Key for Backup Vault Encryption
resource "aws_kms_key" "backup_key" {
  description             = "KMS key for backup vault encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = var.tags
}

resource "aws_kms_alias" "backup_key_alias" {
  name          = "alias/${var.kms_key_alias}"
  target_key_id = aws_kms_key.backup_key.id
}

# Backup Vault
resource "aws_backup_vault" "main_vault" {
  name          = var.backup_vault_name
  kms_key_arn   = aws_kms_key.backup_key.arn

  tags = var.tags
}

# Backup Plan with Rules (RPO/RTO compliant)
resource "aws_backup_plan" "main_plan" {
  name = var.backup_plan_name

  rule {
    rule_name         = "DailyBackupRule"
    target_vault_name = aws_backup_vault.main_vault.name
    schedule          = var.backup_schedule_expression # e.g., cron(0 2 * * ? *)
    lifecycle {
      delete_after = var.delete_after_days # e.g., 35
    }
    recovery_point_tags = merge(var.tags, {
      "BackupFrequency" = "Daily"
    })
  }

  dynamic "rule" {
    for_each = var.additional_backup_rules
    content {
      rule_name         = rule.value.rule_name
      target_vault_name = aws_backup_vault.main_vault.name
      schedule          = rule.value.schedule
      lifecycle {
        delete_after = rule.value.delete_after_days
      }
      recovery_point_tags = merge(var.tags, rule.value.additional_tags)
    }
  }

  tags = var.tags
}

# Backup Selection by Tags
resource "aws_backup_selection" "selection_by_tags" {
  name         = "TagBasedSelection"
  iam_role_arn = aws_iam_role.backup_role.arn
  plan_id      = aws_backup_plan.main_plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = var.backup_tag_key
    value = var.backup_tag_value
  }
}

# IAM Role for Backup
resource "aws_iam_role" "backup_role" {
  name = "${var.backup_plan_name}_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "backup.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "backup_policy_attach" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

# Optional: Backup notifications via SNS
resource "aws_backup_vault_notifications" "vault_notifications" {
  count              = var.enable_sns_notifications ? 1 : 0
  backup_vault_name  = aws_backup_vault.main_vault.name
  sns_topic_arn      = var.sns_topic_arn
  backup_vault_events = ["BACKUP_JOB_COMPLETED", "RESTORE_JOB_COMPLETED"]
}
