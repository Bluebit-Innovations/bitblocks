module "synthetic_guardrails" {
  source           = "../../sec_prem_synthetic_guardrails"  # Adjust based on your folder structure
  name_prefix      = "bluebit-sec-api"
  artifact_bucket  = "my-secure-canary-artifacts"
  zip_file_path =  "${path.module}/scripts/scripts.zip"
  alarm_actions    = ["arn:aws:sns:us-east-1:123456789012:SecurityAlarms"]

  tags = {
    Environment = "prod"
    Module      = "sec_synthetic_guardrails"
  }
}
