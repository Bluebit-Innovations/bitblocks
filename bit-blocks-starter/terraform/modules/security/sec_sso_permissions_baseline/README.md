
# SSO Permission Baseline (sec_sso_permissions_baseline)

## 📌 Overview

The `sec_sso_permissions_baseline` Terraform module provides a production-grade setup for centralizing IAM access in AWS using **IAM Identity Center (formerly AWS SSO)**. This module automates the creation of permission sets, assignment of least-privilege policies, and binding to AWS accounts and users/groups — enabling secure, scalable identity and access management across environments.

---

## 🚀 Features

- ✅ Create one or more **IAM Identity Center Permission Sets**
- 🔐 Assign AWS **managed policies** per set
- 🧑‍🤝‍🧑 Assign users or groups to permission sets across multiple AWS accounts
- ⏱ Control **session duration** and optionally define **relay states**
- 💼 Tag permission sets for cost tracking or ownership
- 🧩 Supports greenfield and brownfield use cases

---

## 📁 Module Structure

```

├── main.tf
├── variables.tf
├── outputs.tf
├── basic.tf
└── advanced.tf

````

---

## 🧠 Use Cases

- Centralized access provisioning for multiple accounts via Identity Center
- Least privilege policy enforcement using managed policies
- Scalable, repeatable identity automation across dev/staging/prod
- Compliance with security best practices (MFA enforcement, role separation)

---

## 🔧 Usage

### Basic Example

```hcl
module "sso_permissions_baseline" {
  source = "../../"

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
      principal_id       = "user-12345678"
      principal_type     = "USER"
      target_account_id  = "111122223333"
    }
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
````

### Advanced Example

```hcl

module "sso_permissions_baseline" {
  source = "../../d"

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
      principal_id       = "group-abcdef01"
      principal_type     = "GROUP"
      target_account_id  = "444455556666"
    }

    "dev-team-staging" = {
      permission_set     = "DevOpsAccess"
      principal_id       = "user-fedcba98"
      principal_type     = "USER"
      target_account_id  = "777788889999"
    }

    "billing-lead" = {
      permission_set     = "BillingAccess"
      principal_id       = "user-99998888"
      principal_type     = "USER"
      target_account_id  = "111122223333"
    }
  }

  tags = {
    Owner      = "Bluebit"
    Department = "Platform Engineering"
  }
}

```
---

## 📥 Inputs

| Name                           | Description                                                | Type                                                                                                       | Required |
| ------------------------------ | ---------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | -------- |
| `identity_center_instance_arn` | ARN of the IAM Identity Center instance                    | `string`                                                                                                   | ✅ Yes    |
| `permission_sets`              | Map of permission sets with settings and attached policies | `map(object)` with fields: `description`, `session_duration`, `relay_state` (optional), `managed_policies` | ✅ Yes    |
| `assignments`                  | IAM Identity Center account assignments                    | `map(object)` with fields: `permission_set`, `principal_id`, `principal_type`, `target_account_id`         | ✅ Yes    |
| `tags`                         | Tags to apply to permission sets                           | `map(string)`                                                                                              | ❌ No     |

---

## 📤 Outputs

| Name              | Description                                                                             |
| ----------------- | --------------------------------------------------------------------------------------- |
| `permission_sets` | Map of permission set names to metadata including `arn`, `name`, and `session_duration` |

---

## 🧩 Future Enhancements

* 🔄 Support for **inline policy attachment**
* 🕵️‍♂️ MFA policy enforcement per session
* 📂 Optional loading of policy documents via `file()` + `jsondecode()`
* 🧪 Add pre-deployment validation or compliance guardrails

---

## ✅ Requirements

* Terraform v1.3+
* AWS provider v5.0+
* IAM Identity Center (SSO) enabled and configured
* Permission to call `ssoadmin:*` APIs

---

## 📜 License

MIT License

---

## 🏢 Maintained by [Bluebit Information Technology Services](https://bluebit.live)

Feel free to reach out at [info@bluebit.live](mailto:info@bluebit.live) or call +971 562034575 for support, customization, or deployment assistance.

