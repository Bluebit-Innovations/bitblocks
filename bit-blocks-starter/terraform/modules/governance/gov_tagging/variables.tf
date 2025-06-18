variable "tag_policy_name" {
  type        = string
  description = "Name of the AWS Tag Policy"
}

variable "tag_policy_description" {
  type        = string
  default     = "Enforce required tags across resources"
  description = "Tag policy description"
}

variable "target_ou_id" {
  type        = string
  description = "The AWS Organization OU or account ID to attach the tag policy to"
}

variable "config_resource_types" {
  type        = list(string)
  default     = ["AWS::EC2::Instance", "AWS::S3::Bucket"]
  description = "List of AWS resource types to enforce tags via AWS Config"
}

variable "enable_sns_alerts" {
  type        = bool
  default     = false
  description = "Enable SNS compliance alerts for tag violations"
}
