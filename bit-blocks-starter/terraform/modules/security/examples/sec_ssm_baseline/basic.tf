module "sec_ssm_baseline_basic" {
  source = "../../sec_ssm_baseline"

  patch_baseline_name   = "baseline-linux"
  operating_system      = "AMAZON_LINUX_2"
  approved_patches      = []
  approve_after_days    = 7
  compliance_level      = "CRITICAL"
  enable_non_security   = false
  patch_classifications = ["Security"]
  patch_severities      = ["Critical", "Important"]

  config_doc_name = "bluebit-secure-config"
  config_doc_file = "documents/baseline_doc.yaml"

  patching_cron = "rate(7 days)"
  instance_ids  = ["i-0123456789abcdef0"]

  tags = {
    Environment = "dev"
    Owner       = "ops"
  }
}
