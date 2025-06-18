output "backup_vault_arn" {
  description = "ARN of the Backup Vault"
  value       = aws_backup_vault.main_vault.arn
}

output "backup_plan_id" {
  description = "ID of the AWS Backup Plan"
  value       = aws_backup_plan.main_plan.id
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for Backup encryption"
  value       = aws_kms_key.backup_key.arn
}
