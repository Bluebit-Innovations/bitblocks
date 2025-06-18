output "snapshot_alert_sns_topic_arn" {
  description = "ARN of the SNS topic for snapshot alerts."
  value       = aws_sns_topic.snapshot_alerts_topic.arn
}

output "dlm_lifecycle_policy_arn" {
  description = "ARN of the lifecycle policy for snapshot retention."
  value       = aws_dlm_lifecycle_policy.snapshot_retention_policy.arn
}
