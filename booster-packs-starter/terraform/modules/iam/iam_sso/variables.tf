# Identity store variables
# These variables are used to create an identity store user and group
# in AWS Identity Store. The identity store is used to manage user identities
# and groups for AWS SSO. The variables are defined as follows:

variable "users" {
  description = "A map of users to be created in the identity store"
  type        = map(object({
    user_name     = string
    display_name  = string
    given_name    = string
    family_name   = string
    email_value   = string
    email_primary = bool
    email_type    = string
  }))
  default = {}
}

variable "enable_group_creation" {
  description = "Whether to create Identity Store groups from groups.yaml"
  type        = bool
  default     = true
}
variable "groups" {
  description = "A map of groups to be created in the identity store"
  type        = map(object({
    display_name = string
    description  = string
  }))
  default = {}
}



variable "identity_source_type" {
  description = "Type of identity source to use: AWS or EXTERNAL"
  type        = string
  default     = "EXTERNAL"
  validation {
    condition     = contains(["AWS", "EXTERNAL"], var.identity_source_type)
    error_message = "identity_source_type must be either AWS or EXTERNAL"
  }
}

# No longer needed as we are using the identity store ID from the data source

# variable "identity_center_instance_arn" {
#   description = "ARN of the AWS Identity Center instance"
#   type        = string
# }

# variable "identity_store_id" {
#   description = "The ID of the AWS Identity Store"
#   type        = string
#   default     = null
# }

# Variables for config file to create groups
variable "group_config_file" {
  description = "Path to the groups.yaml file from root module"
  type        = string
}

# Variables permission set and account assignments
variable "permission_sets" {
  description = "List of permission sets to be created"
  type = list(object({
    name        = string
    description = optional(string)
    policy_arn  = string
  }))
}

variable "account_assignments" {
  description = "List of user/group to account assignments"
  type = list(object({
    target_type    = string
    target_id      = string
    permission_set = string
    account_id     = string
  }))
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
    default = ""
}

variable "enable_scp" {
    description = "Flag to enable/disable Service Control Policies"
    type        = bool
    default     = false
}

variable "environment" {
    description = "Environment name (prod, staging, dev, global)"
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
    default = " "
}


# variable "name" {
#     description = "The name of the CloudFormation stack"
#     type        = string
# }

# variable "application_id" {
#     description = "The ID of the serverless application"
#     type        = string
# }

# variable "semantic_version" {
#     description = "The semantic version of the application"
#     type        = string
# }

# variable "capabilities" {
#     description = "A list of capabilities to allow in the CloudFormation stack"
#     type        = list(string)
# }

# variable "parameters" {
#     description = "A map of parameters to pass to the CloudFormation stack"
#     type        = map(string)
# }