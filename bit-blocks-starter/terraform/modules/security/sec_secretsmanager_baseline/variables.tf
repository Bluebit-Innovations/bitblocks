variable "region" {
  description = "AWS region."
  type        = string
}

variable "secret_name" {
  description = "Name for Secrets Manager secret."
  type        = string
}

variable "secret_description" {
  description = "Description of the secret."
  type        = string
  default     = "Managed by Terraform"
}

variable "kms_alias_name" {
  description = "Alias for the KMS key."
  type        = string
  default     = "secretsmanager-key"
}

variable "kms_deletion_window" {
  description = "Deletion window for KMS key in days."
  type        = number
  default     = 7
}

variable "enable_kms_rotation" {
  description = "Enable automatic rotation for KMS key."
  type        = bool
  default     = true
}

variable "rotation_days" {
  description = "Days after which secrets rotate automatically."
  type        = number
  default     = 30
}

variable "enable_rotation" {
  description = "Enable rotation via Lambda."
  type        = bool
  default     = false
}

variable "lambda_zip_path" {
  description = "Path to Lambda deployment zip file."
  type        = string
  default     = ""
}

variable "lambda_handler" {
  description = "Handler for Lambda rotation function."
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description = "Runtime for Lambda rotation."
  type        = string
  default     = "python3.10"
}

variable "lambda_env_vars" {
  description = "Environment variables for Lambda function."
  type        = map(string)
  default     = {}
}

variable "enable_usage_alerts" {
  description = "Enable CloudWatch alerts for secret usage."
  type        = bool
  default     = false
}

variable "access_alert_threshold" {
  description = "Threshold for secret access alarms."
  type        = number
  default     = 10
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for notifications."
  type        = string
  default     = ""
}

variable "recovery_window" {
  description = "Recovery window before permanent deletion."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags for AWS resources."
  type        = map(string)
  default     = {}
}
