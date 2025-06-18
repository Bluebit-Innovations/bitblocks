variable "patch_baseline_name" {
  description = "Name of the SSM patch baseline"
  type        = string
}

variable "approved_patches" {
  description = "List of explicitly approved patches"
  type        = list(string)
  default     = []
}

variable "operating_system" {
  description = "Operating system (e.g., AMAZON_LINUX_2, WINDOWS)"
  type        = string
}

variable "approve_after_days" {
  description = "Days after release to approve patches"
  type        = number
  default     = 7
}

variable "compliance_level" {
  description = "Compliance severity level"
  type        = string
  default     = "CRITICAL"
}

variable "enable_non_security" {
  description = "Whether to approve non-security patches"
  type        = bool
  default     = false
}

variable "patch_classifications" {
  description = "Patch classifications to include"
  type        = list(string)
  default     = ["Security"]
}

variable "patch_severities" {
  description = "Patch severities to include"
  type        = list(string)
  default     = ["Critical", "Important"]
}

variable "config_doc_name" {
  description = "Name of the custom config SSM Document"
  type        = string
}

variable "config_doc_file" {
  description = "Local JSON/YAML file containing the SSM Document content"
  type        = string
}

variable "patching_cron" {
  description = "CRON expression for patch schedule"
  type        = string
  default     = "rate(7 days)"
}

variable "instance_ids" {
  description = "Target instance IDs for SSM associations"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
