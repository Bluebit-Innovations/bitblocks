module "sec_ssm_baseline_advanced" {
  source = "../../sec_ssm_baseline"

  patch_baseline_name   = "bluebit-prod-baseline"
  operating_system      = "AMAZON_LINUX_2"
  approved_patches      = ["patch-xyz-2024"]
  approve_after_days    = 3
  compliance_level      = "HIGH"
  enable_non_security   = true
  patch_classifications = ["Security", "Bugfix"]
  patch_severities      = ["Critical", "Important", "Medium"]

  config_doc_name = "bluebit-hardened-config"
  config_doc_file = "documents/baseline_doc.yaml"

  patching_cron = "cron(0 3 ? * SUN *)"
  instance_ids  = [
    "i-0abcdef1234567890",
    "i-0987654321fedcba0"
  ]

  tags = {
    Environment = "production"
    Compliance  = "CIS"
    Owner       = "security-team"
    Module      = "sec_ssm_baseline"
  }
}
