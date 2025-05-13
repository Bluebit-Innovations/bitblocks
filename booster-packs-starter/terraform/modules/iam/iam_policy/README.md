
# 🛡️ IAM Policy Module

This Terraform module allows you to:

- Create an AWS IAM policy
- Attach it to one or more IAM roles
- Attach managed policies to an AWS SSO permission set
- Assign an inline policy to an SSO permission set

It is production-ready, supports modular use, and works with both greenfield and brownfield AWS environments.

---

## 🚀 Usage

### ✅ Basic Example (No SSO)

```hcl
module "iam_policy_basic" {
  source      = "../../modules/iam_policy"

  name        = "basic-readonly-policy"
  description = "Grants read-only access to S3"
  path        = "/"

  policy_json = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["s3:ListBucket", "s3:GetObject"],
        Resource = "*"
      }
    ]
  })

  attach_to_roles = ["readonly-role"]
  enable_sso      = false
}
```

### 🔐 SSO Enabled Example with Managed Policies

```hcl
module "iam_policy_sso" {
  source = "../../modules/iam_policy"

  name                     = "sso-managed-access"
  description              = "Attach managed policies via SSO"
  policy_json              = jsonencode({})
  enable_sso               = true
  sso_instance_arn         = "arn:aws:sso:::instance/ssoins-EXAMPLE"
  sso_permission_set_arn   = "arn:aws:sso:::permissionSet/ssoins-EXAMPLE/ps-EXAMPLE"
  sso_managed_policy_arns  = [
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  ]
}
```

---

## 📥 Input Variables

| Name                      | Type           | Default | Description                                                 |
| ------------------------- | -------------- | ------- | ----------------------------------------------------------- |
| `name`                    | `string`       | —       | Name of the IAM policy                                      |
| `path`                    | `string`       | `"/"`   | Path for the IAM policy                                     |
| `description`             | `string`       | `""`    | Description of the IAM policy                               |
| `policy_json`             | `string`       | —       | JSON content of the IAM policy                              |
| `tags`                    | `map(string)`  | `{}`    | Tags to apply to the policy                                 |
| `attach_to_roles`         | `list(string)` | `[]`    | List of IAM role names to attach the policy to              |
| `enable_sso`              | `bool`         | `false` | Flag to enable SSO-related resources                        |
| `sso_instance_arn`        | `string`       | `null`  | ARN of the AWS SSO instance                                 |
| `sso_permission_set_arn`  | `string`       | `null`  | ARN of the AWS SSO permission set                           |
| `sso_managed_policy_arns` | `list(string)` | `[]`    | List of managed policy ARNs to attach to the permission set |

---

## 📤 Output Variables

| Name                | Description                                           |
| ------------------- | ----------------------------------------------------- |
| `policy_arn`        | The ARN of the created IAM policy                     |
| `attachment_status` | Indicates if the policy was attached to any IAM roles |

---

## ✅ Notes

* This module is designed for role-based and SSO-first access control strategies.
* IAM users and groups are intentionally excluded for security and scalability.
* `enable_sso = true` must be used alongside valid SSO ARNs.
* Supports multi-environment deployment (dev, staging, prod) when composed correctly.

---

## 📜 License

MIT © Bluebit Information Technology Services

---
