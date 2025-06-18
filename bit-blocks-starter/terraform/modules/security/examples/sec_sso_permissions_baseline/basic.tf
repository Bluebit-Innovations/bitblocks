module "sso_permissions_baseline_basic" {
  source = "../../sec_sso_permissions_baseline"

  identity_center_instance_arn = "arn:aws:sso:::instance/ssoins-EXAMPLE"

  permission_sets = {
    "ViewOnlyAccess" = {
      description       = "Grants read-only access"
      session_duration  = "PT1H"
      managed_policies  = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
    }
  }


  assignments = {
    "assignment1" = {
      permission_set     = "ViewOnlyAccess"
      principal_id       = "08f7c0a3-41dd-4e99-b6cb-e2b25e3d3e3f" 
      principal_type     = "USER"
      target_account_id  = "111122223333"
    }
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
