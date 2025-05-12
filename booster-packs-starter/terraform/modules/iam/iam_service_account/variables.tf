variable "service_account_name" {
  description = "Name of the service account"
  type        = string
}

variable "assume_role_policy" {
  description = "JSON policy for service account assume role"
  type        = string
}


variable "service_account_policy_arns" {
  description = "List of ARNs of the IAM policies to attach to the service account role"
  type        = list(string)
}

variable "create_sso_permission_set" {
  description = "Whether to create an AWS SSO permission set for the service account"
  type        = bool
  default     = false
}

variable "sso_instance_arn" {
  description = "ARN of the AWS SSO instance"
  type        = string
  default     = null
}

variable "service_account_description" {
  description = "Description of the service account"
  type        = string
  default     = null
}

variable "ssoadmin_permission_set_name" {
  description = "Name of the AWS SSO permission set"
  type        = string
  default     = null
}



variable "ssoadmin_permission_set_description" {
  description = "Description of the AWS SSO permission set"
  type        = string
  default     = null
}



# Add a variable to control Access Analyzer resources creation
variable "enable_access_analyzer" {
    description = "Flag to enable/disable IAM Access Analyzer"
    type        = bool
    default     = false
}

variable "enable_cloudtrail" {
    description = "Flag to enable/disable CloudTrail monitoring"
    type        = bool
    default     = false
}

variable "cloudtrail_bucket_name" {
    description = "Name of the S3 bucket for CloudTrail logs"
    type        = string
}

variable "enable_scp" {
    description = "Flag to enable/disable Service Control Policies"
    type        = bool
    default     = false
}

variable "environment" {
    description = "Environment name (prod, staging, dev)"
    type        = string
}

variable "tags" {
    description = "A map of tags to assign to the resources"
    type        = map(string)
    default     = {}
}

variable "group_name" {
    description = "Name of the IAM group"
    type        = string
}



