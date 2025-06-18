

module "sec_s3_policy_hardener_advanced" {
  source = "../../sec_prem_s3_policy_hardener"

  enabled            = true
  create_remediation = true

  # Optional: Add support for custom remediation role if module supports it
  # remediation_role_arn = "arn:aws:iam::123456789012:role/custom-ssm-remediation-role"

  # Optional: Extend module to support tag filtering or alerting via SNS
  # tag_key_filter   = "Environment"
  # tag_value_filter = "production"

  # Optional: Enable or disable specific rules
  # enable_public_read_rule  = true
  # enable_public_write_rule = true
}
