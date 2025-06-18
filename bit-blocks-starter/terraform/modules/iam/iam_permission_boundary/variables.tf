variable "name" {
  description = "Name of the IAM permission boundary policy"
  type        = string
}

variable "description" {
  description = "Description of the permission boundary policy"
  type        = string
  default     = "IAM Permission Boundary"
}

variable "allowed_actions" {
  description = "List of allowed IAM actions"
  type        = list(string)
}

variable "resource_arns" {
  description = "List of resource ARNs the actions apply to"
  type        = list(string)
}

variable "target_roles" {
  description = "List of IAM roles to attach the permission boundary to"
  type        = list(string)
  default     = []
}

variable "attach_to_existing_roles" {
  description = "Attach permission boundary to existing roles"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the permission boundary policy"
  type        = map(string)
  default     = {}
}
