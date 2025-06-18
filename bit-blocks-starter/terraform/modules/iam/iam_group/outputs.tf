output "iam_group_arn" {
  description = "The ARN of the IAM group"
  value       = aws_iam_group.this.arn
}

output "iam_group_name" {
  description = "The name of the IAM group"
  value       = aws_iam_group.this.name
}

output "iam_group_id" {
  description = "The ID of the IAM group"
  value       = aws_iam_group.this.id
}

output "iam_group_users" {
  description = "The list of IAM users in the IAM group"
  value       = aws_iam_group_membership.this.users
}

output "iam_group_path" {
  description = "The path of the IAM group"
  value       = aws_iam_group.this.path
}

# output "iam_group_membership" {
#   description = "The list of IAM group memberships"
#   value       = aws_iam_group_membership.this.users
# }

# output "iam_group_inline_policies" {
#   description = "The list of IAM inline policies to the IAM group"
#   value       = aws_iam_group_policy.this.policy
# }

# output "iam_group_managed_policies" {
#   description = "The list of IAM managed policies to the IAM group"
#   value       = aws_iam_group_policy_attachment.this.policy_arns
# }

