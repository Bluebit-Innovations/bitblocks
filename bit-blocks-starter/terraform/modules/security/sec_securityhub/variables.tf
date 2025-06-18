variable "enable_securityhub" {
  description = "Enable AWS Security Hub"
  type        = bool
  default     = true
}

variable "enable_cis_standard" {
  description = "Enable CIS Benchmark Standard in Security Hub"
  type        = bool
  default     = true
}

variable "enable_aggregator" {
  description = "Enable centralized aggregator across regions"
  type        = bool
  default     = true
}

variable "member_accounts" {
  description = "List of member accounts to invite to Security Hub"
  type        = map(string)
  default     = {}
}

variable "enable_third_party_products" {
  description = "Enable integration with third-party tools"
  type        = bool
  default     = false
}

variable "third_party_product_arns" {
  description = "List of third-party product ARNs to subscribe to"
  type        = list(string)
  default     = []
}

variable "enable_eventbridge" {
  description = "Enable EventBridge forwarding of findings"
  type        = bool
  default     = false
}

variable "findings_target_arn" {
  description = "ARN of SNS topic, Lambda, or other EventBridge target"
  type        = string
  default     = ""
}

variable "enable_aws_config" {
  description = "Enable AWS Config to record compliance history"
  type        = bool
  default     = false
}

variable "config_role_arn" {
  description = "IAM role ARN for AWS Config to assume"
  type        = string
  default     = ""
}

variable "config_snapshot_bucket_name" {
  description = "S3 bucket name for AWS Config snapshots"
  type        = string
  default     = ""
}

variable "snapshot_transition_days" {
  description = "Number of days before transitioning snapshots to Glacier"
  type        = number
  default     = 30
}

variable "snapshot_expiration_days" {
  description = "Number of days before expiring snapshots"
  type        = number
  default     = 365
}
