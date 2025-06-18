module "iam_access_analyzer_advanced" {
  source                 = "../../gov_accessanalyzer"
  analyzer_name          = "org-analyzer"
  analyzer_type          = "ORGANIZATION"
  enabled                = true
  enable_archive_rule    = true
  archive_rule_name      = "suppress-public-s3"
  archive_filters = [
    {
      criteria = "resourceType"
      eq       = ["AWS::S3::Bucket"]
    },
    {
      criteria = "isPublic"
      eq       = ["true"]
    }
  ]
  enable_sns_alerts      = true
  sns_topic_name         = "access-analyzer-alerts"
  alert_email            = "security@example.com"
  enable_aws_config      = true
  config_bucket_name     = "my-config-log-bucket"
  tags = {
    Environment = "production"
    Team        = "security"
  }
}