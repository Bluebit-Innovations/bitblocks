module "sso_permissions_baseline" {
  source = "../../iam_sso"
  test_mode             = true
  environment = "dev"

  account_assignments = [
    {
      target_type    = "USER"
      target_id      = "user-12345678"
      permission_set = "ViewOnlyAccess"
      account_id     = "111122223333"
    }
  ]

  permission_sets = [
    {
      name        = "ViewOnlyAccess"
      description = "Grants read-only access"
      policy_arn  = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    }
  ]

  group_config_file = "groups.yaml"
}



# Basic Example: Single Permission Set with Group Assignment

module "sso" {
  source = "../../iam_sso"

  test_mode   = true
  environment = "dev"

  permission_sets = [
    {
      name        = "ReadOnlyAccess"
      description = "Provides read-only access to AWS resources."
      policy_arn  = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    }
  ]

  account_assignments = [
    {
      target_type    = "GROUP"
      target_id      = "readonly-team"
      permission_set = "ReadOnlyAccess"
      account_id     = "111111111111"
    }
  ]


  group_config_file = "groups.yaml"
}
