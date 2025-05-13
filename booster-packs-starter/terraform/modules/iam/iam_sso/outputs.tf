output "permission_set_arns" {
  value = { for k, ps in aws_ssoadmin_permission_set.this : k => ps.arn }
}

output "assignments" {
  value = aws_ssoadmin_account_assignment.this
}
output "permission_set_ids" {
  value = { for k, ps in aws_ssoadmin_permission_set.this : k => ps.id }
}
