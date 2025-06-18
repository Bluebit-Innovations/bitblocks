
#############################
# examples/advanced.tf
#############################

module "gov_audit_advanced" {
  source = "../../gov_audit"

  config_bucket_name       = "central-audit-logs"
  config_role_arn          = "arn:aws:iam::123456789012:role/ConfigRecorderRole"
  aggregator_role_arn      = "arn:aws:iam::123456789012:role/AggregatorRole"
  aggregator_account_id    = "123456789012"

  enable_config            = true
  enable_guardduty         = true
  enable_security_hub      = true
  enable_sh_findings_agg   = true
  enable_cross_region_agg  = true
  enable_aggregator        = true
  assign_delegated_admin   = true
  enable_custom_rules      = true

  conformance_pack_names   = ["Operational-Best-Practices-for-NIST-CSF"]
  security_hub_standards   = [
    "aws-foundational-security-best-practices",
    "cis-aws-foundations-benchmark"
  ]

  enable_log_archive       = true
  log_bucket_name          = "log-archive-bucket"
  enable_sns_notify        = true
  sns_topic_arn            = "arn:aws:sns:us-east-1:123456789012:audit-topic"
  alert_email              = "compliance@example.com"

  default_tags = {
    Environment = "Production"
    Project     = "GovAudit"
  }

  regions = ["us-east-1", "eu-west-1"]
}
