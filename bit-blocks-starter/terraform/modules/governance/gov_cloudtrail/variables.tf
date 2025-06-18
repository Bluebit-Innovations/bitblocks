variable "enable_trail" {
  description = "Enable or disable the CloudTrail logging module"
  type        = bool
  default     = true
}

variable "trail_name" {
  description = "Name of the CloudTrail"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to deliver CloudTrail logs"
  type        = string
}

variable "create_s3_bucket" {
  description = "Whether to create the S3 bucket for CloudTrail logs"
  type        = bool
  default     = true
}

variable "enable_cloudwatch" {
  description = "Whether to send logs to CloudWatch Logs"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
  default     = "/aws/cloudtrail/logs"
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 90
}

variable "is_organization_trail" {
  description = "Whether this trail is an org-wide trail"
  type        = bool
  default     = false
}

variable "account_id" {
  description = "The AWS Account ID"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key ARN for encrypting logs if not creating a new one"
  type        = string
  default     = ""
}

variable "create_kms_key" {
  description = "Whether to create a KMS key for CloudTrail log encryption"
  type        = bool
  default     = false
}

variable "enable_insights" {
  description = "Enable CloudTrail Insights for detecting unusual activity"
  type        = bool
  default     = false
}

variable "is_multi_region_trail" {
  description = "Enable multi-region CloudTrail"
  type        = bool
  default     = true
}

variable "enable_lifecycle_rules" {
  description = "Enable lifecycle rules for CloudTrail S3 bucket"
  type        = bool
  default     = false
}

variable "archive_after_days" {
  description = "Days after which logs are transitioned to Glacier"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
