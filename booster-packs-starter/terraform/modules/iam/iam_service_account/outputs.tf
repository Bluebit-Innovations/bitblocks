output "service_account_arn" {
  description = "The ARN of the service account"
  value       = aws_iam_role.this.arn
}

output "service_account_name" {
  description = "The name of the service account"
  value       = aws_iam_role.this.name
}

output "service_account_create_date" {
  description = "The creation date of the service account"
  value       = aws_iam_role.this.create_date
}

output "service_account_policy_arns" {
  description = "The list of ARNs of the IAM policies attached to the service account role"
  value       = aws_iam_role_policy_attachment.managed_policy[*].policy_arn
}

output "service_account_sso_permission_set_arn" {
  description = "The ARN of the AWS SSO permission set for the service account"
  value       = var.create_sso_permission_set ? aws_ssoadmin_permission_set.this[0].arn : null
}

output "service_account_sso_permission_set_name" {
  description = "The name of the AWS SSO permission set for the service account"
  value       = var.create_sso_permission_set ? aws_ssoadmin_permission_set.this[0].name : null
}

output "service_account_sso_permission_set_description" {
  description = "The description of the AWS SSO permission set for the service account"
  value       = var.create_sso_permission_set ? aws_ssoadmin_permission_set.this[0].description : null
}

output "service_account_sso_permission_set_session_duration" {
  description = "The session duration of the AWS SSO permission set for the service account"
  value       = var.create_sso_permission_set ? aws_ssoadmin_permission_set.this[0].session_duration : null
}

output "service_account_sso_permission_set_managed_policy_arns" {
  description = "The list of ARNs of the managed policies attached to the AWS SSO permission set for the service account"
  value       = var.create_sso_permission_set ? aws_ssoadmin_managed_policy_attachment.this[*].managed_policy_arn : []
}

output "service_account_sso_permission_set_instance_arn" {
  description = "The ARN of the AWS SSO instance for the AWS SSO permission set for the service account"
  value       = var.create_sso_permission_set ? aws_ssoadmin_permission_set.this[0].instance_arn : null
}


