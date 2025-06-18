variable "enable_for_organization" {
  description = "Enable Inspector2 at the organization level"
  type        = bool
  default     = false
}

variable "resource_types" {
  description = "List of resource types to enable for scanning (e.g. EC2, ECR, Lambda)"
  type        = list(string)
  default     = ["EC2", "ECR"]
}

variable "auto_enable_ec2" {
  description = "Automatically enable EC2 scanning for new accounts"
  type        = bool
  default     = true
}

variable "auto_enable_ecr" {
  description = "Automatically enable ECR scanning for new accounts"
  type        = bool
  default     = true
}

variable "auto_enable_lambda" {
  description = "Automatically enable Lambda function scanning for new accounts"
  type        = bool
  default     = false
}

variable "delegated_admin_account_id" {
  description = "AWS Account ID to designate as the delegated admin for Inspector2 (used only when org mode is enabled)"
  type        = string
  default     = ""
}

variable "account_ids" {
  description = "List of AWS Account IDs to enable Inspector2 for (used only when org mode is disabled)"
  type        = list(string)
  default     = []
}