output "access_analyzer_arn" {
  description = "ARN of the IAM Access Analyzer"
  value       = var.enable_access_analyzer ? aws_accessanalyzer_analyzer.default[0].arn : null
}

output "access_analyzer_id" {
  description = "Name (ID) of the IAM Access Analyzer"
  value       = var.enable_access_analyzer ? aws_accessanalyzer_analyzer.default[0].id : null
}

output "auditor_role_arn" {
  description = "ARN of the ReadOnly Auditor role"
  value       = var.create_readonly_role ? aws_iam_role.auditor[0].arn : null
}

output "athena_workgroup" {
  description = "Athena workgroup name"
  value       = var.enable_athena_logs ? aws_athena_workgroup.iam_audit[0].name : null
}

output "athena_bucket" {
  description = "S3 bucket for IAM logs and Athena results"
  value       = var.enable_athena_logs ? aws_s3_bucket.iam_logs[0].bucket : null
}
