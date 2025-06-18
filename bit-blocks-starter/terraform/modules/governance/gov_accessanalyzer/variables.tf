variable "enabled" {
  description = "Toggle to enable or disable the module"
  type        = bool
  default     = true
}

variable "analyzer_name" {
  description = "Name for the IAM Access Analyzer"
  type        = string
  default     = "access-analyzer"
}

variable "analyzer_type" {
  description = "Type of analyzer: ACCOUNT or ORGANIZATION"
  type        = string
  default     = "ACCOUNT"
  validation {
    condition     = contains(["ACCOUNT", "ORGANIZATION"], var.analyzer_type)
    error_message = "analyzer_type must be ACCOUNT or ORGANIZATION"
  }
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

# Archive Rule
variable "enable_archive_rule" {
  description = "Enable suppression rules for findings"
  type        = bool
  default     = false
}

variable "archive_rule_name" {
  description = "Name of the archive rule"
  type        = string
  default     = "suppress-public-resources"
}

variable "archive_filters" {
  description = "List of filter blocks for the archive rule"
  type = list(object({
    criteria = string
    eq       = list(string)
  }))
  default = []
}

# SNS Alerts
variable "enable_sns_alerts" {
  description = "Enable SNS alerts for new findings"
  type        = bool
  default     = false
}

variable "sns_topic_name" {
  description = "SNS topic name for alerts"
  type        = string
  default     = "access-analyzer-alerts"
}

variable "alert_email" {
  description = "Email address for alerts"
  type        = string
  default     = ""
}

# AWS Config
variable "enable_aws_config" {
  description = "Enable AWS Config integration"
  type        = bool
  default     = false
}

variable "config_bucket_name" {
  description = "S3 bucket name for AWS Config delivery"
  type        = string
  default     = "config-logs-bucket"
}
