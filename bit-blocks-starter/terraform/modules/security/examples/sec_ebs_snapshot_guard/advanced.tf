module "advanced_snapshot_guard" {
  source      = "../../sec_ebs_snapshot_guard"
  name_prefix = "advanced-ebs-guard"

  alert_emails      = ["security-team@example.com", "compliance@example.com"]
  retention_count   = 14
  retention_interval = 12
  snapshot_time    = "00:00"
}
