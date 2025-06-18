module "sec_compliance_findings_advanced" {
  source = "../../sec_securityhub"

  enable_securityhub      = true
  enable_cis_standard     = true
  enable_aggregator       = true

  member_accounts = {
    "111122223333" = "security@example.com"
    "444455556666" = "audit@example.com"
  }

  enable_third_party_products = true
  third_party_product_arns = [
    "arn:aws:securityhub:us-east-1::product/aws/guardduty",
    "arn:aws:securityhub:us-east-1::product/aws/inspector"
  ]

  enable_eventbridge  = true
  findings_target_arn = "arn:aws:sns:us-east-1:123456789012:SecurityFindingsTopic"

  enable_aws_config           = true
  config_role_arn             = "arn:aws:iam::123456789012:role/AWSConfigRecorderRole"
  config_snapshot_bucket_name = "company-compliance-archive"
  snapshot_transition_days    = 30
  snapshot_expiration_days    = 365
}
