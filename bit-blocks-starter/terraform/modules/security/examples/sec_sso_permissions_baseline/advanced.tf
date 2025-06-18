module "sso_permissions_baseline_advanced" {
  source = "../../sec_sso_permissions_baseline"

  identity_center_instance_arn = "arn:aws:sso:::instance/ssoins-EXAMPLE"

  permission_sets = {
    "AdminAccess" = {
      description       = "Full administrative privileges"
      session_duration  = "PT4H"
      relay_state       = "https://console.aws.amazon.com/"
      managed_policies  = [
        "arn:aws:iam::aws:policy/AdministratorAccess"
      ]
    }

    "BillingAccess" = {
      description       = "Billing and Cost Management"
      session_duration  = "PT2H"
      relay_state       = null
      managed_policies  = [
        "arn:aws:iam::aws:policy/job-function/Billing"
      ]
    }

    "DevOpsAccess" = {
      description       = "Access for developers and DevOps engineers"
      session_duration  = "PT2H"
      relay_state       = null
      managed_policies  = [
        "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess",
        "arn:aws:iam::aws:policy/AWSCloudFormationFullAccess"
      ]
    }
  }

  assignments = {
    "admin-group-prod" = {
      permission_set     = "AdminAccess"
      principal_id       = "08f7c0a3-41dd-4e99-b6cb-e2b25e2c1ab2"
      principal_type     = "GROUP"
      target_account_id  = "444455556666"
    }

    "dev-team-staging" = {
      permission_set     = "DevOpsAccess"
      principal_id       = "08f7c0a3-41dd-4e99-b6cb-e2b25e3d3e3f"
      principal_type     = "USER"
      target_account_id  = "777788889999"
    }

    "billing-lead" = {
      permission_set     = "BillingAccess"
      principal_id       = "08f7c0a3-41dd-4e24-b6cb-e2b25e2c1ab2"
      principal_type     = "USER"
      target_account_id  = "111122223333"
    }
  }

  tags = {
    Owner      = "Bluebit"
    Department = "Platform Engineering"
  }
}
