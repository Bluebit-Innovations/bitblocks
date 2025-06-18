module "basic_snapshot_guard" {
  source      = "../../sec_ebs_snapshot_guard"
  name_prefix = "basic-ebs-guard"

  alert_emails = ["alerts@example.com"]
}
