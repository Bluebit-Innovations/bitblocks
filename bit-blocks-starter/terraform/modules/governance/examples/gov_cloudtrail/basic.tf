# 🎯 What This Does:
# - Creates a CloudTrail trail with multi-region enabled
# - Creates an S3 bucket for logs (no lifecycle rules)
# - Does not enable CloudWatch, KMS key creation, or insights

module "gov_cloudtrail_basic" {
  source              = "../../gov_cloudtrail"
  enable_trail        = true
  trail_name          = "core-audit-basic"
  s3_bucket_name      = "my-basic-cloudtrail-logs"
  create_s3_bucket    = true
  account_id          = "123456789012"
  is_multi_region_trail = true
  is_organization_trail = false

  # Optional: basic tags
  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}
