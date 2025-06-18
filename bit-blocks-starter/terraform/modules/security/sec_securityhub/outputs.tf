output "securityhub_enabled" {
  value       = var.enable_securityhub
  description = "Whether Security Hub is enabled"
}

output "aggregator_enabled" {
  value       = var.enable_aggregator
  description = "Whether regional aggregator is enabled"
}

output "eventbridge_rule_arn" {
  value       = try(aws_cloudwatch_event_rule.securityhub_findings[0].arn, "")
  description = "ARN of EventBridge rule for findings"
}

output "aws_config_enabled" {
  value       = var.enable_aws_config
  description = "Whether AWS Config is enabled"
}

output "config_snapshot_bucket_name" {
  value       = try(aws_s3_bucket.config_snapshot[0].bucket, "")
  description = "Name of the S3 bucket storing compliance snapshots"
}
