output "patch_baseline_id" {
  value       = aws_ssm_patch_baseline.this.id
  description = "ID of the created patch baseline"
}

output "document_name" {
  value       = aws_ssm_document.baseline_config.name
  description = "Name of the secure config document"
}

output "patch_association_id" {
  value       = aws_ssm_association.patching.id
  description = "ID of the patching SSM association"
}

output "config_association_id" {
  value       = aws_ssm_association.secure_config.id
  description = "ID of the secure config SSM association"
}
