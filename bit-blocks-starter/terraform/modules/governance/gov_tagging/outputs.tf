output "tag_policy_id" {
  description = "The ID of the AWS Tag Policy"
  value       = aws_organizations_policy.tag_policy.id
}

output "sns_topic_arn" {
  description = "The ARN of the compliance SNS topic"
  value       = var.enable_sns_alerts ? aws_sns_topic.compliance_alerts[0].arn : null

}
