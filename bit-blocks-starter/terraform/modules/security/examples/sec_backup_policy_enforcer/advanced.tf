module "backup_policy_advanced" {
  source = "../../sec_backup_policy_enforcer"

  region                   = "us-east-1"
  backup_vault_name        = "critical_workloads_vault"
  backup_plan_name         = "critical_rpo_rto_plan"
  kms_key_alias            = "critical_backup_encryption_key"
  backup_schedule_expression = "cron(0 1 * * ? *)"
  delete_after_days        = 90

  additional_backup_rules = [
    {
      rule_name         = "WeeklyFullBackup"
      schedule          = "cron(0 3 ? * SUN *)"
      delete_after_days = 180
      additional_tags   = { "BackupFrequency" = "Weekly" }
    }
  ]

  enable_sns_notifications = true
  sns_topic_arn            = "arn:aws:sns:us-east-1:123456789012:BackupNotifications"

  tags = {
    Environment = "Critical"
    Compliance  = "SOC2"
  }
}
