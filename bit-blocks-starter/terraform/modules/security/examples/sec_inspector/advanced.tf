module "inspector_advanced" {
  source                      = "../../sec_inspector"
  enable_for_organization     = true
  resource_types              = ["EC2", "ECR", "LAMBDA"]
  delegated_admin_account_id  = "123456789012"
  account_ids                 = ["111122223333", "444455556666"]
  auto_enable_ec2             = true
  auto_enable_ecr             = true
  auto_enable_lambda          = true
}
