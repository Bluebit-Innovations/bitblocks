output "role_arn" {
  value = aws_iam_role.this.arn
}

output "role_name" {
  value = aws_iam_role.this.name
}

output "instance_profile_arn" {
  value       = var.create_instance_profile ? aws_iam_instance_profile.this[0].arn : null
  description = "ARN of the instance profile"
}
