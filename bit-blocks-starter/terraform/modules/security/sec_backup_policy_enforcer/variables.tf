variable "region" {
  type        = string
  description = "AWS Region for resources"
}

variable "backup_vault_name" {
  type        = string
  description = "The name of the AWS Backup Vault"
  default     = "production_backup_vault"
}

variable "backup_plan_name" {
  type        = string
  description = "Name for the AWS Backup Plan"
  default     = "production_backup_plan"
}

variable "kms_key_alias" {
  type        = string
  description = "Alias name for the KMS key"
  default     = "backup_vault_key"
}

variable "backup_schedule_expression" {
  type        = string
  description = "Cron expression defining backup schedule"
  default     = "cron(0 2 * * ? *)" # Daily at 2 AM UTC
}

variable "delete_after_days" {
  type        = number
  description = "Retention period in days for backups"
  default     = 35
}

variable "backup_tag_key" {
  type        = string
  description = "Tag key for selecting resources to backup"
  default     = "Backup"
}

variable "backup_tag_value" {
  type        = string
  description = "Tag value for selecting resources to backup"
  default     = "Enabled"
}

variable "additional_backup_rules" {
  type = list(object({
    rule_name           = string
    schedule            = string
    delete_after_days   = number
    additional_tags     = map(string)
  }))
  description = "Additional backup rules to be added"
  default     = []
}

variable "enable_sns_notifications" {
  type        = bool
  description = "Toggle SNS notifications for backup jobs"
  default     = false
}

variable "sns_topic_arn" {
  type        = string
  description = "ARN of the SNS topic for notifications"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to all resources"
  default     = {}
}
