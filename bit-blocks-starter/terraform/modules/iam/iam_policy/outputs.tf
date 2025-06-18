output "policy_arn" {
  description = "The ARN of the created IAM policy"
  value       = aws_iam_policy.this.arn
}

output "attachment_status" {
  description = "Whether the policy was attached to any roles"
  value       = length(var.roles_to_attach) > 0 ? "attached" : "not attached"
}