variable "scp_policies" {
  description = <<EOF
List of SCP policy objects.

Fields:
- name: policy name
- description: policy description
- policy_inline: JSON string content (optional if using file)
- policy_file_path: path to policy file (optional if using inline)
- use_policy_file: bool to decide which source to use
- enabled: flag to enable/disable
- target_ids: OUs or accounts
- environment: env context (prod/dev/staging)
- tags: AWS tags
EOF

  type = list(object({
    name             = string
    description      = optional(string, "Managed SCP")
    policy_inline    = optional(string)
    policy_file_path = optional(string)
    use_policy_file  = optional(bool, false)
    tags             = optional(map(string), {})
    target_ids       = list(string)
    enabled          = optional(bool, true)
    environment      = optional(string, "global")
  }))
}


variable "allowed_environments" {
  description = "List of environments where SCPs should be attached"
  type        = list(string)
  default     = ["dev", "staging", "prod"]
}
