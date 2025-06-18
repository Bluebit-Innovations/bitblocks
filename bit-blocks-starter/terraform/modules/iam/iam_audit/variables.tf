variable "prefix" {
  description = "Prefix to use for all resources"
  type        = string
  default     = "iam-audit"
}

variable "enable_access_analyzer" {
  description = "Enable IAM Access Analyzer"
  type        = bool
  default     = true
}

variable "enable_config_rules" {
  description = "Enable IAM-related AWS Config Rules"
  type        = bool
  default     = true
}

variable "create_readonly_role" {
  description = "Create a ReadOnly Auditor IAM Role"
  type        = bool
  default     = true
}

variable "trusted_auditor_arns" {
  description = "List of ARNs that can assume the read-only audit role"
  type        = list(string)
  default     = []
}

variable "enable_athena_logs" {
  description = "Enable Athena + S3 setup for logging IAM actions"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
