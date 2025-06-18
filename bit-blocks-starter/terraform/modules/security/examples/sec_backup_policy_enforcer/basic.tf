module "backup_policy_basic" {
  source = "../../sec_backup_policy_enforcer"

  region = "us-east-1"

  tags = {
    Environment = "Production"
    Owner       = "OpsTeam"
  }
}
