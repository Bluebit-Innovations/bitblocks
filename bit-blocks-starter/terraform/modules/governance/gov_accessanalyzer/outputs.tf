output "analyzer_arn" {
    # The ARN of the IAM Access Analyzer, used to analyze IAM policies for security and compliance.
    description = "IAM Access Analyzer ARN"
    value       = var.enabled ? aws_accessanalyzer_analyzer.this[0].arn : null
}

output "sns_topic_arn" {
    # The ARN of the SNS Topic used for sending alerts, if SNS alerts are enabled.
    description = "SNS Topic ARN for alerts"
    value       = (var.enable_sns_alerts && var.enabled) ? aws_sns_topic.this[0].arn : null
}

output "config_bucket_name" {
    # The name of the S3 bucket used to store AWS Config logs, if AWS Config is enabled.
    description = "Name of AWS Config S3 bucket"
    value       = (var.enable_aws_config && var.enabled) ? aws_s3_bucket.config_logs[0].id : null
}
