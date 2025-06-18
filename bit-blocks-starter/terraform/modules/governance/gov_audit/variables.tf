
#############################
# variables.tf
#############################

variable "config_bucket_name" {
  type        = string
  description = "S3 bucket name to deliver AWS Config logs"
}

variable "config_role_arn" {
  type        = string
  description = "IAM Role ARN used by AWS Config"
}

variable "aggregator_role_arn" {
  type        = string
  description = "IAM Role ARN to be assumed by AWS Config aggregator"
}

variable "aggregator_account_id" {
  type        = string
  default     = null
  description = "Aggregator account ID for delegated admin setup"
}

variable "enable_config" {
  type    = bool
  default = true
}

variable "enable_guardduty" {
  type    = bool
  default = true
}

variable "enable_security_hub" {
  type    = bool
  default = true
}

variable "enable_sh_findings_agg" {
  type    = bool
  default = true
}

variable "enable_aggregator" {
  type    = bool
  default = true
}

variable "enable_cross_region_agg" {
  type    = bool
  default = true
}

variable "organization_enabled" {
  type    = bool
  default = true
}

variable "assign_delegated_admin" {
  type    = bool
  default = false
}

variable "conformance_pack_names" {
  type    = list(string)
  default = []
}

variable "security_hub_standards" {
  type    = list(string)
  default = ["aws-foundational-security-best-practices"]
}

variable "enable_custom_rules" {
  type    = bool
  default = false
}

variable "enable_log_archive" {
  type    = bool
  default = false
}

variable "log_bucket_name" {
  type    = string
  default = null
}

variable "enable_sns_notify" {
  type    = bool
  default = false
}

variable "sns_topic_arn" {
  type    = string
  default = null
}

variable "alert_email" {
  type    = string
  default = null
}

variable "default_tags" {
  type    = map(string)
  default = {}
}

variable "regions" {
  type    = list(string)
  default = ["us-east-1"]
}