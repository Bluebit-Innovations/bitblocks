module "iam_access_analyzer" {
  source         = "../../gov_accessanalyzer"
  analyzer_name  = "prod-access-analyzer"
  analyzer_type  = "ACCOUNT"
  tags = {
    Project = "GovernanceBooster"
    Env     = "prod"
  }
}