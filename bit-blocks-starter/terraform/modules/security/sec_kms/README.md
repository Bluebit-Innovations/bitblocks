# AWS KMS Key Management Module (`sec_kms`)

This Terraform module is part of the **Security Booster Pack** for AWS, designed to manage the full lifecycle of KMS (Key Management Service) encryption keys including creation, rotation, alias management, auditing, and grants.

## 🎯 Purpose

This module helps AWS customers:

- Create and manage KMS keys for encryption at rest and in-transit.
- Automate aliasing for service-specific access.
- Enforce security best practices such as key rotation.
- Manage access through fine-grained grant definitions.
- Accelerate readiness for compliance standards like ISO 27001, HIPAA, PCI-DSS, and SOC 2.

---

## 🚀 Features

- ✅ Production-grade KMS key resource
- 🔁 Key rotation support
- 🧠 Custom alias assignment
- 📜 Optional policy and grants
- 🌍 Multi-region key support
- 🔐 Secure by default with auditing readiness

---

## 📦 Module Usage

### Basic Usage

```hcl
module "kms_basic" {
  source              = "path_to_module"
  alias_name          = "basic-key"
  key_description     = "A simple KMS key"
  enable_key_rotation = true
}
````

### Advanced Usage with Grant Management

```hcl
module "kms_advanced" {
  source                  = "path_to_module"
  alias_name              = "app-secrets-key"
  key_description         = "KMS key for encrypting application secrets"
  deletion_window_in_days = 7
  multi_region            = true
  create_grants           = true

  grants = [
    {
      name                      = "AppServerAccess"
      grantee_principal         = "arn:aws:iam::123456789012:role/app-server"
      operations                = ["Encrypt", "Decrypt"]
      encryption_context_equals = { "App" = "Finance" }
    }
  ]
}
```

---

## 🔧 Input Variables

| Name                      | Description                                        | Type           | Default                  | Required |
| ------------------------- | -------------------------------------------------- | -------------- | ------------------------ | -------- |
| `alias_name`              | Alias name (without `alias/` prefix)               | `string`       | n/a                      | ✅ Yes    |
| `key_description`         | Description of the KMS key                         | `string`       | `"Managed by Terraform"` | No       |
| `deletion_window_in_days` | Days before deletion if key is scheduled           | `number`       | `30`                     | No       |
| `enable_key_rotation`     | Enables automatic key rotation                     | `bool`         | `true`                   | No       |
| `is_enabled`              | Whether the key is enabled                         | `bool`         | `true`                   | No       |
| `multi_region`            | Create a multi-region key                          | `bool`         | `false`                  | No       |
| `key_policy`              | Custom key policy in JSON string format            | `string`       | `null`                   | No       |
| `tags`                    | Tags to apply to resources                         | `map(string)`  | `{}`                     | No       |
| `create_grants`           | Whether to define grants for key access            | `bool`         | `false`                  | No       |
| `grants`                  | List of grant objects for fine-grained permissions | `list(object)` | `[]`                     | No       |

### Grant Object Schema

```hcl
{
  name                      = string
  grantee_principal         = string
  operations                = list(string)
  encryption_context_equals = map(string)
}
```

---

## 📤 Outputs

| Name         | Description                   |
| ------------ | ----------------------------- |
| `key_id`     | The ID of the created KMS key |
| `key_arn`    | The ARN of the KMS key        |
| `alias_name` | The alias assigned to the key |

---

## 🛡️ Compliance & Best Practices

* AWS Key Rotation: Enabled by default.
* Secure Deletion: Supports a 7–30 day deletion window.
* Principle of Least Privilege: Uses IAM grants when needed.
* Multi-Region Readiness: Optional multi-region key support.
* Auditing: Can be integrated with CloudTrail and AWS Config.

---

## 📎 Related AWS Services

* **AWS CloudTrail** – Monitor KMS usage and key management
* **AWS IAM** – Define policies and grants for KMS access
* **AWS Config** – Audit KMS configuration over time
* **Amazon S3 / EBS / RDS / Secrets Manager** – Encrypt data with managed keys

---

## ✅ Recommendations

* Use **separate KMS keys per environment** (prod, dev, staging).
* Integrate **CloudTrail and Config** for audit trail visibility.
* Regularly review and rotate grants if using `create_grants = true`.

---

## 🔒 License

MIT License. See `LICENSE` file for more information.

---

## 🤝 Maintainers

Module maintained by the **Bluebit Cloud Security Team**.
For support or enterprise onboarding, contact: [info@bluebit.live](mailto:info@bluebit.live)
