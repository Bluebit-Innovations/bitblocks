variable "name_prefix" {
  type        = string
  description = "Prefix for naming all resources."
}

variable "alert_emails" {
  type        = list(string)
  description = "Email addresses for SNS alerts. Leave empty to disable."
  default     = []
}

variable "retention_count" {
  type        = number
  description = "Number of snapshots to retain."
  default     = 7
}

variable "retention_interval" {
  type        = number
  description = "Interval between snapshot creations in hours."
  default     = 24
}

variable "snapshot_time" {
  type        = string
  description = "UTC time (HH:MM) when snapshot creation should occur. Only one value is allowed."
  default     = "00:00"
}

