output "permission_set_arns" {
  value = { for k, ps in aws_ssoadmin_permission_set.this : k => ps.arn }
}

output "assignments" {
  value = aws_ssoadmin_account_assignment.this
}
output "permission_set_ids" {
  value = { for k, ps in aws_ssoadmin_permission_set.this : k => ps.id }
}

output "identity_store_id_debug" {
  value = var.test_mode ? null : data.aws_ssoadmin_instances.this[0].identity_store_ids[0]
}