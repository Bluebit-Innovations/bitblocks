module "gov_org_basic" {
  source = "../../gov_org"

  organizational_units = {
    core = { name = "Core" }
    dev  = { name = "Development" }
    prod = { name = "Production" }
  }

  create_accounts = false

  service_integrations = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com"
  ]

  delegated_administrators = {}
}
