module "inspector_basic" {
  source           = "../../sec_inspector"
  enable_for_organization = false
  resource_types   = ["EC2", "ECR"]
  delegated_admin_account_id = ""
  account_ids      = ["111122223333", "444455556666"]
}