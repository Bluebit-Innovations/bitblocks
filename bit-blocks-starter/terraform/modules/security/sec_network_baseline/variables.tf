variable "vpc_id" {
  description = "The ID of the VPC to apply network baseline security"
  type        = string
}

variable "default_network_acl_id" {
  description = "ID of the default NACL associated with the VPC"
  type        = string
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_log_destination_type" {
  description = "Type of log destination for VPC flow logs: 's3' or 'cloud-watch-logs'"
  type        = string
  default     = "cloud-watch-logs"
}

variable "flow_log_retention_days" {
  description = "Retention period for CloudWatch Logs"
  type        = number
  default     = 30
}

variable "name_prefix" {
  description = "Prefix for resource naming"
  type        = string
  default     = "baseline"
}

variable "prevent_public_subnet_access" {
  description = "Prevent default SG from allowing public subnet access"
  type        = bool
  default     = true
}
