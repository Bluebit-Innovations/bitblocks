variable "web_acl_name" {
  description = "Name of the WAF Web ACL"
  type        = string
}

variable "scope" {
  description = "Scope of the WAF Web ACL: REGIONAL or CLOUDFRONT"
  type        = string
  default     = "REGIONAL"
}

variable "resource_arn" {
  description = "ARN of the resource to associate with WAF & Shield (e.g., ALB, CloudFront)"
  type        = string
  default     = ""
}

variable "enable_shield_protection" {
  description = "Enable AWS Shield Advanced Protection"
  type        = bool
  default     = false
}

variable "enable_protection_group" {
  description = "Enable creation of Shield protection group"
  type        = bool
  default     = false
}

variable "shield_group_members" {
  description = "List of resource ARNs to include in Shield protection group"
  type        = list(string)
  default     = []
}

variable "shield_group_name" {
  description = "Name of the Shield protection group"
  type        = string
  default     = "bluebit-sec-group"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
