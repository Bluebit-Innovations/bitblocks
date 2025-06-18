# 🎯 What This Does:
# - Enables CloudTrail Insights for suspicious behavior detection
# - Sends logs to both S3 and CloudWatch
# Creates a KMS key for encryption (auto-managed)
# Enables S3 lifecycle rules for archiving to Glacier after 60 days
# Enables org-wide logging across multiple accounts
# Enables multi-region log collection

module "gov_cloudtrail_advanced" {
  source                   = "../../gov_cloudtrail"
  enable_trail             = true
  trail_name               = "enterprise-org-wide-trail"
  s3_bucket_name           = "my-org-cloudtrail-logs"
  create_s3_bucket         = true
  account_id               = "123456789012"
  is_multi_region_trail    = true
  is_organization_trail    = true

  # Enable CloudWatch logs
  enable_cloudwatch         = true
  cloudwatch_log_group_name = "/aws/cloudtrail/organization"
  log_retention_days        = 180

  # Enable lifecycle rules
  enable_lifecycle_rules    = true
  archive_after_days        = 60

  # Enable insights detection
  enable_insights           = true

  # KMS key management (let module create it)
  create_kms_key            = true

  tags = {
    Environment = "prod"
    Compliance  = "SOC2"
    Owner       = "Bluebit"
  }
}
