output "permission_boundary_policy_arn" {
  description = "ARN of the created permission boundary IAM policy"
  value       = aws_iam_policy.permission_boundary.arn
}

output "attached_roles" {
  description = "List of roles the permission boundary was attached to"
  value       = var.attach_to_existing_roles ? var.target_roles : []
}
