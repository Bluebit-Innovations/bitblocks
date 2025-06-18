# IAM Permission Boundary Module

This Terraform module creates an AWS IAM permission boundary and optionally attaches it to existing IAM roles.

## Features

- Creates a least-privilege permission boundary policy
- Allows attachment to existing IAM roles
- Easily integratable in greenfield or brownfield projects

## Usage

```hcl
module "iam_boundary" {
  source  = "../modules/iam_permission_boundary"

  name                = "prod-boundary-policy"
  description         = "Boundary limiting IAM actions"
  allowed_actions     = ["s3:ListBucket", "dynamodb:GetItem"]
  resource_arns       = ["arn:aws:s3:::mybucket/*", "arn:aws:dynamodb:region:account-id:table/my-table"]
  target_roles        = ["my-existing-role"]
  attach_to_existing_roles = true

  tags = {
    Environment = "prod"
    Project     = "core-security"
  }
}
````


---

### 📥 Inputs

| Name                       | Description                                            | Type           | Default                     | Required |
| -------------------------- | ------------------------------------------------------ | -------------- | --------------------------- | -------- |
| `name`                     | Name of the IAM permission boundary policy             | `string`       | —                           | ✅ Yes    |
| `description`              | Description of the permission boundary policy          | `string`       | `"IAM Permission Boundary"` | ❌ No     |
| `allowed_actions`          | List of allowed IAM actions                            | `list(string)` | —                           | ✅ Yes    |
| `resource_arns`            | List of resource ARNs the actions apply to             | `list(string)` | —                           | ✅ Yes    |
| `target_roles`             | List of IAM roles to attach the permission boundary to | `list(string)` | `[]`                        | ❌ No     |
| `attach_to_existing_roles` | Whether to attach to existing IAM roles                | `bool`         | `false`                     | ❌ No     |
| `tags`                     | Tags to apply to the IAM policy                        | `map(string)`  | `{}`                        | ❌ No     |

---

### 📤 Outputs

| Name                             | Description                                           |
| -------------------------------- | ----------------------------------------------------- |
| `permission_boundary_policy_arn` | The ARN of the created boundary IAM policy            |
| `attached_roles`                 | List of roles the permission boundary was attached to |

---



