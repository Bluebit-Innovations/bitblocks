output "scp_ids" {
  value       = { for k, v in aws_organizations_policy.scp : k => v.id }
  description = "IDs of the created SCPs"
}

output "scp_arns" {
  value       = { for k, v in aws_organizations_policy.scp : k => v.arn }
  description = "ARNs of the created SCPs"
}
