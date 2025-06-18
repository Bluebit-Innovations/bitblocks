# gov_org – AWS Organizations Governance Module

This Terraform module sets up an AWS Organization with Organizational Units (OUs), optionally creates and assigns AWS accounts to OUs, and configures delegated administrator accounts for supported AWS services.

> ⚡ Part of the AWS Governance Booster Pack

---

## ✅ Features

- Creates an AWS Organization with `ALL` features enabled
- Defines and creates OUs (Organizational Units)
- (Optional) Creates and assigns AWS accounts to OUs
- (Optional) Assigns delegated administrator roles for services to specific accounts

---

## 📦 Usage Examples

### Basic Example

```hcl
module "gov_org" {
  source = "../modules/gov_org"

  organizational_units = {
    core = { name = "Core" }
    dev  = { name = "Development" }
    prod = { name = "Production" }
  }

  create_accounts = false

  delegated_administrators = {}
}
````

### Advanced Example with Accounts and Delegated Admins

```hcl
module "gov_org" {
  source = "../modules/gov_org"

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
    billing_account = {
      name      = "Billing Account"
      email     = "billing@myorg.com"
      role_name = "OrganizationAccountAccessRole"
      ou_key    = "billing"
    }
  }

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
```

---

## 🔧 Input Variables

| Name                       | Type                                                                                                         | Description                                                                                                                   | Default      |
| -------------------------- | ------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------- | ------------ |
| `organizational_units`     | `map(object({ name = string }))`                                                                             | Map of OUs to create. Key = reference name.                                                                                   | **required** |
| `create_accounts`          | `bool`                                                                                                       | Whether to create AWS accounts using this module. If false, `managed_accounts` is ignored.                                    | `false`      |
| `managed_accounts`         | `map(object({ name = string, email = string, role_name = string, ou_key = string }))`                        | AWS accounts to create and assign to OUs.                                                                                     | `{}`         |
| `delegated_administrators` | `map(object({ account_key = optional(string), account_id = optional(string), service_principal = string }))` | Map of services to delegate to accounts. Use `account_key` if using `create_accounts = true`; otherwise provide `account_id`. | `{}`         |

---

## 📤 Outputs

| Name                      | Description                      |
| ------------------------- | -------------------------------- |
| `organization_id`         | ID of the AWS Organization       |
| `root_id`                 | ID of the root organization unit |
| `organizational_unit_ids` | Map of OU keys to OU IDs         |

---

## ⚠️ Service Integration Notice

AWS does **not currently support a Terraform resource** to enable organization-wide service access (e.g., `aws organizations enable-aws-service-access`). To enable services like `config.amazonaws.com`, you must either:

* Use the AWS CLI:

  ```bash
  aws organizations enable-aws-service-access --service-principal config.amazonaws.com
  ```
* Or use a `null_resource` with a `local-exec` provisioner (if CLI is available)

Example (optional):

```hcl
resource "null_resource" "enable_services" {
  for_each = toset([
    "config.amazonaws.com",
    "guardduty.amazonaws.com"
  ])

  provisioner "local-exec" {
    command = "aws organizations enable-aws-service-access --service-principal ${each.value}"
  }
}
```

---

## 🔐 Notes & Best Practices

* Run this module from the **management account** of your AWS Organization.
* Use `parent_id` during `aws_organizations_account` creation to assign accounts to specific OUs.
* Enable CloudTrail, Config, and other services **manually** or using CLI after this setup.
* Each AWS service allows **only one** delegated admin in an Org.

---

## 📚 Common AWS Service Principals for Delegated Admin

| Service         | Service Principal               |
| --------------- | ------------------------------- |
| AWS Config      | `config.amazonaws.com`          |
| GuardDuty       | `guardduty.amazonaws.com`       |
| Security Hub    | `securityhub.amazonaws.com`     |
| Access Analyzer | `access-analyzer.amazonaws.com` |
| Billing         | `billing.amazonaws.com`         |

---

## 📜 License

MIT License © 2025 Bluebit

---

## 🤝 Maintainers

This module is maintained by the [Bluebit Infrastructure Team](https://bluebit.live)