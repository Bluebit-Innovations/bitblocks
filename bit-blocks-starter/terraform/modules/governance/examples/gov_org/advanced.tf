#Simple Advanced example

module "gov_org_advanced" {
  source = "../../gov_org"

  organizational_units = {
    security = { name = "Security" }
    billing  = { name = "Billing" }
  }

  create_accounts = true

  managed_accounts = {
    sec = {
      name      = "Security Account"
      email     = "security@example.com"
      role_name = "OrganizationAccountAccessRole"
      ou_key    = "security"
    }
    bill = {
      name      = "Billing Account"
      email     = "billing@example.com"
      role_name = "OrganizationAccountAccessRole"
      ou_key    = "billing"
    }
  }

  delegated_administrators = {
    guardduty = {
      account_key       = "sec"
      service_principal = "guardduty.amazonaws.com"
    }
    config = {
      account_key       = "sec"
      service_principal = "config.amazonaws.com"
    }
    billing = {
      account_key       = "bill"
      service_principal = "billing.amazonaws.com"
    }
  }

  service_integrations = [
    "guardduty.amazonaws.com",
    "config.amazonaws.com",
    "billing.amazonaws.com"
  ]
}


# Complete advanced example

module "gov_org_complete" {
  source = "../../gov_org"

  organizational_units = {
    security = { name = "Security" }
    dev      = { name = "Development" }
    prod     = { name = "Production" }
    billing  = { name = "Billing" }
  }

  create_accounts = true

  managed_accounts = {
    security_account = {
      name      = "Security Account"
      email     = "security@myorg.com"
      role_name = "OrganizationAccountAccessRole"
      ou_key    = "security"
    }

    dev_account = {
      name      = "Dev Account"
      email     = "dev@myorg.com"
      role_name = "OrganizationAccountAccessRole"
      ou_key    = "dev"
    }

    prod_account = {
      name      = "Prod Account"
      email     = "prod@myorg.com"
      role_name = "OrganizationAccountAccessRole"
      ou_key    = "prod"
    }

    billing_account = {
      name      = "Billing Account"
      email     = "billing@myorg.com"
      role_name = "OrganizationAccountAccessRole"
      ou_key    = "billing"
    }
  }

  service_integrations = [
    "guardduty.amazonaws.com",
    "config.amazonaws.com",
    "billing.amazonaws.com"
  ]

  delegated_administrators = {
    guardduty = {
      account_key       = "security_account"
      service_principal = "guardduty.amazonaws.com"
    }

    config = {
      account_key       = "security_account"
      service_principal = "config.amazonaws.com"
    }

    billing = {
      account_key       = "billing_account"
      service_principal = "billing.amazonaws.com"
    }
  }
}
# Note: The above example assumes that the necessary IAM roles and policies are already in place for the accounts.