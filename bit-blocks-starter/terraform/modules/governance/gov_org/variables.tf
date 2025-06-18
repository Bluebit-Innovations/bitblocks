variable "organizational_units" {
  description = "Map of Organizational Units to create"
  type = map(object({
    name = string
  }))
}

variable "create_accounts" {
  description = "Whether to create and invite managed accounts"
  type        = bool
  default     = false
}

variable "managed_accounts" {
  description = "Map of accounts to create and assign to OUs"
  type = map(object({
    name      = string
    email     = string
    role_name = string
    ou_key    = string
  }))
  default = {}
}

variable "service_integrations" {
  description = "List of AWS services to enable for organization"
  type        = list(string)
  default     = ["cloudtrail.amazonaws.com", "config.amazonaws.com"]
}

variable "delegated_administrators" {
  description = <<EOT
Map of services to delegate to specific accounts.
Key = logical name; 
Value = {
  account_key       = key in managed_accounts (if create_accounts = true)
  OR
  account_id        = existing AWS Account ID (if create_accounts = false)
  service_principal = AWS service principal (e.g. guardduty.amazonaws.com)
}
EOT
  type = map(object({
    account_key       = optional(string)
    account_id        = optional(string)
    service_principal = string
  }))
  default = {}
}

