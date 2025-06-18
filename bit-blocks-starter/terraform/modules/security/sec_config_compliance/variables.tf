variable "recorder_name" {
  type        = string
  default     = "default"
  description = "Name of the config recorder"
}

variable "recorder_role_arn" {
  type        = string
  description = "ARN of the IAM role used by AWS Config"
}

variable "delivery_channel_name" {
  type        = string
  default     = "default"
}

variable "delivery_s3_bucket" {
  type        = string
  description = "S3 bucket for AWS Config delivery"
}

variable "delivery_sns_topic_arn" {
  type        = string
  default     = null
  description = "SNS topic for compliance notifications"
}

variable "enable_conformance_pack" {
  type    = bool
  default = false
}

variable "conformance_pack_name" {
  type        = string
  default     = "default-pack"
}

variable "conformance_pack_s3_bucket" {
  type        = string
  default     = null
}

variable "conformance_pack_s3_prefix" {
  type        = string
  default     = null
}

variable "conformance_pack_template_body" {
  type        = string
  default     = null
  description = "YAML body of the conformance pack"
}

variable "conformance_pack_template_s3_uri" {
  type        = string
  default     = null
  description = "S3 URI for the conformance pack template"
}

variable "global_resource_region" {
  type        = string
  default     = "us-east-1"
}

variable "custom_rules" {
  type = map(object({
    lambda_function_arn      = string
    input_parameters         = map(string)
    max_execution_frequency  = string
    resource_types           = list(string)
  }))
  default = {}
}


variable "conformance_pack_input_parameters" {
  type        = map(string)
  default     = {}
  description = "Input parameters for the conformance pack template"
}
