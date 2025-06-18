output "trail_arn" {
  value       = var.enable_trail ? aws_cloudtrail.this[0].arn : null
  description = "ARN of the created CloudTrail"
}

output "s3_bucket_name" {
  value       = var.s3_bucket_name
  description = "S3 bucket name used for CloudTrail"
}

output "kms_key_arn" {
  value       = var.create_kms_key ? aws_kms_key.cloudtrail[0].arn : null
  description = "KMS Key ARN used for encryption"
}