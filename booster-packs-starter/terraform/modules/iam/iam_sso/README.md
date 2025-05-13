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
                ├── lambda_sync/        # Optional: Self-managed SCIM sync workaround
examples/
  sso-google-workspace/
  sso-azuread/
  sso-okta/

```

## Usage

```hcl
module "iam_sso" {
    source = "./terraform-modules/iam/iam_sso"
    
    permission_sets = {
        "AdministratorAccess" = {
            description = "Provides full access to AWS services and resources"
            session_duration = "PT4H"
            managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
        }
    }

    account_assignments = {
        "admin-assignment" = {
            account_id = "123456789012"
            permission_set_arn = module.iam_sso.permission_set_arns["AdministratorAccess"]
            principal_id = "d-1234567890"
            principal_type = "GROUP"
        }
    }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| sso_group_name | The name of the SSO group | `string` | yes |
| permission_sets | Map of permission sets to create. Each set includes description, session duration, and managed policies | `map(object({description = string, session_duration = string, managed_policies = list(string)}))` | yes |
| account_assignments | Map of account assignments to create. Each assignment includes account ID, permission set ARN, principal ID and type | `map(object({account_id = string, permission_set_arn = string, principal_id = string, principal_type = string}))` | yes |
| enable_access_analyzer | Flag to enable/disable IAM Access Analyzer | `bool` | no |
| enable_cloudtrail | Flag to enable/disable CloudTrail monitoring | `bool` | no |
| cloudtrail_bucket_name | Name of the S3 bucket for CloudTrail logs | `string` | yes |
| enable_scp | Flag to enable/disable Service Control Policies | `bool` | no |
| environment | Environment name (prod, staging, dev) | `string` | yes |
| tags | A map of tags to assign to the resources | `map(string)` | no |
| group_name | Name of the IAM group | `string` | yes |

## Outputs

| Name | Description |
|------|-------------|
| permission_set_arns | ARNs of the created permission sets |
| managed_policy_attachment_arns | ARNs of the created managed policy attachments |
| account_assignment_ids | IDs of the created account assignments |
| instance_arn | ARN of the SSO instance |
| permission_set_ids | IDs of the created permission sets |
| managed_policy_attachment_ids | IDs of the created managed policy attachments |
| instance_arns | ARNs of the created SSO instances |
| instance_identity_store_id | Identity store ID of the created SSO instances |
