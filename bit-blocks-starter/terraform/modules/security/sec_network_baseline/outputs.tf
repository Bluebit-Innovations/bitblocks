output "flow_log_id" {
  value       = try(aws_flow_log.vpc_flow_log[0].id, null)
  description = "The ID of the VPC Flow Log"
}

output "flow_log_destination" {
  value = var.flow_log_destination_type == "s3" ? try(aws_s3_bucket.flow_log_bucket[0].arn, null) : try(aws_cloudwatch_log_group.flow_logs[0].arn, null)
  description = "The destination for the VPC flow logs"
}
