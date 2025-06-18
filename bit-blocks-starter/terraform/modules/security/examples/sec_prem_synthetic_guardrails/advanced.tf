

resource "aws_sns_topic" "alerts" {
  name = "synthetic-canary-alerts"
}

resource "aws_s3_bucket" "canary_artifacts" {
  bucket = "bluebit-canary-artifacts-1124243213"  # Ensure this bucket name is globally unique
  force_destroy = true

  tags = {
    Name        = "Canary Artifacts"
    Environment = "prod"
  }
}

module "synthetic_guardrails_advanced" {
  source = "../../sec_prem_synthetic_guardrails"  # Adjust based on your folder structure

  name_prefix      = "bluebit-internal-api"
  artifact_bucket  = aws_s3_bucket.canary_artifacts.bucket
  zip_file_path =  "${path.module}/scripts/scripts.zip"
  runtime_version  = "syn-nodejs-puppeteer-3.2"
  frequency_minutes = 2
  timeout           = 120
  success_retention = 14
  failure_retention = 60
  auto_start        = true

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  tags = {
    Project     = "SecurityBooster"
    Environment = "staging"
    Owner       = "cloud-team"
    CreatedBy   = "terraform"
  }
}
