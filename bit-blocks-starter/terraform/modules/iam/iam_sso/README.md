# AWS Identity Center (SSO) Terraform Module

This Terraform module provides a **production-ready, plug-and-play solution** for configuring AWS Identity Center (formerly AWS SSO) with external identity providers (IdPs) such as Google Workspace, Azure AD, Okta, or OneLogin. Designed with flexibility and modularity in mind, this module can be integrated into both greenfield and brownfield infrastructure environments.

## 🚀 Features

- ✅ **Vendor-Agnostic** — Supports all major IdPs with SCIM or manual provisioning
- 🔐 **Secure by Default** — Enforces least-privilege access policies via Terraform
- 🔁 **Multi-Account Ready** — Assign permissions across multiple AWS accounts
- 🧩 **Modular Design** — Easily integrates with existing Terraform infrastructure
- 📦 **No Vendor Lock-In** — Fully managed internally; avoids third-party SAR apps like SSOSync
- 🛡️ **Production Grade** — Built to scale securely with AWS best practices

---

## 📦 Module Structure

```text
modules/
    ├── iam/
         ├──sso-identity-center/
                ├── main.tf
                ├── variables.tf
                ├── outputs.tf
                ├── permission_sets.tf
                ├── account_assignments.tf
                ├── lambda_sync/        # Coming Soon: Self-managed SCIM sync workaround
examples/
  sso-google-workspace/
  sso-azuread/
  sso-okta/

```

## Usage

```hcl
module "iam_sso" {
    source = "./terraform-modules/iam/iam_sso"
     
     permission_sets = [
          {
                name        = "AdministratorAccess"
                description = "Provides full access to AWS services and resources"
                policy_arn  = "arn:aws:iam::aws:policy/AdministratorAccess"
          }
     ]

     account_assignments = [
          {
                target_type    = "GROUP"
                target_id      = "d-1234567890"
                permission_set = "AdministratorAccess"
                account_id     = "123456789012"
          }
     ]
}
```

## Inputs

| Name                     | Description                                                                 | Type                                                                 | Required |
|--------------------------|-----------------------------------------------------------------------------|----------------------------------------------------------------------|----------|
| users                    | A map of users to be created in the identity store                         | `map(object({user_name = string, display_name = string, given_name = string, family_name = string, email_value = string, email_primary = bool, email_type = string}))` | no       |
| enable_group_creation    | Whether to create Identity Store groups from groups.yaml                   | `bool`                                                              | no       |
| groups                   | A map of groups to be created in the identity store                        | `map(object({display_name = string, description = string}))`         | no       |
| identity_source_type     | Type of identity source to use: AWS or EXTERNAL                            | `string`                                                            | no       |
| group_config_file        | Path to the groups.yaml file from root module                              | `string`                                                            | no       |
| permission_sets          | List of permission sets to be created                                      | `list(object({name = string, description = optional(string), policy_arn = string}))` | no       |
| account_assignments      | List of user/group to account assignments                                  | `list(object({target_type = string, target_id = string, permission_set = string, account_id = string}))` | no       |
| test_mode                | If true, skip data sources and use dummy static values                     | `bool`                                                              | no       |
| environment              | Environment name (prod, staging, dev, global)                             | `string`                                                            | no       |
| tags                     | A map of tags to assign to the resources                                   | `map(string)`                                                       | no       |
| group_name               | Name of the IAM group                                                      | `string`                                                            | no       |

## Outputs

## Outputs

| Name                  | Description                                      |
|-----------------------|--------------------------------------------------|
| permission_set_arns   | ARNs of the created permission sets              |
| assignments           | Details of the created account assignments       |
| permission_set_ids    | IDs of the created permission sets               |
