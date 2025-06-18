module "sso_permissions_advanced" {
  source = "../../iam_sso"

  test_mode             = true
  group_config_file = "groups.yaml"
  environment = "dev"
  permission_sets = [
    {
      name        = "AdminAccess"
      description = "Full administrative access"
      policy_arn  = "arn:aws:iam::aws:policy/AdministratorAccess"
    },
    {
      name        = "DevOpsEngineer"
      description = "DevOps pipeline and infra automation"
      policy_arn  = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
    },
    {
      name        = "BillingOnly"
      description = "Billing dashboard and cost explorer"
      policy_arn  = "arn:aws:iam::aws:policy/job-function/Billing"
    }
  ]

  account_assignments = [
    {
      target_type    = "GROUP"
      target_id      = "1234567890-08f7c0a3-41dd-4e99-b6cb-e2b25e2c1ab2"
      permission_set = "AdminAccess"
      account_id     = "123456789012"
    },
    {
      target_type    = "USER"
      target_id      = "08f7c0a3-22cc-48e7-8a66-f71d99de34ff"
      permission_set = "DevOpsEngineer"
      account_id     = "210987654321"
    },
    {
      target_type    = "USER"
      target_id      = "0a1b2c3d-4e5f-6789-abcd-ef0123456789"
      permission_set = "BillingOnly"
      account_id     = "102938475610"
    },
    {
      target_type    = "USER"
      target_id      = "08f7c0a3-22cc-48e7-8a66-f71d99de34ff"
      permission_set = "DevOpsEngineer"
      account_id     = "123456789012"
    }
  ]

  tags = {
    Owner        = "Bluebit"
    Department   = "Cloud Engineering"
    Environment  = "production"
    ManagedBy    = "Terraform"
  }
}
