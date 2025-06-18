variable "enabled" {
  type        = bool
  default     = true
  description = "Enable or disable the GuardDuty module."
}

variable "regions" {
  type        = list(string)
  default     = ["us-east-1"]
  description = "List of AWS regions where GuardDuty should be enabled."
}

variable "publish_findings_to_sns" {
  type        = bool
  default     = false
  description = "Enable publishing of GuardDuty findings to an SNS topic."
}

variable "sns_topic_arn" {
  type        = string
  default     = null
  description = "SNS Topic ARN to which GuardDuty findings will be published."
}

variable "enable_organization_admin" {
  type        = bool
  default     = false
  description = "Enable GuardDuty delegated admin setup for AWS Organizations."
}

variable "kms_key_arn" {
  type        = string
  default     = null
  description = "KMS key ARN for encrypting GuardDuty exported findings."
}

variable "tags" {
  type        = map(string)
  default     = {
    Environment = "security"
    Project     = "guardduty"
  }
  description = "Tags to apply to GuardDuty resources."
}


variable "admin_account_id" {
  type        = string
  default     = null
  description = "AWS account ID to set as the GuardDuty delegated administrator."
}