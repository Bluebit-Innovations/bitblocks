# AWS IAM SSO Terraform Module

This module sets up AWS IAM Identity Center (formerly AWS SSO) configurations including permission sets and assignments.This module provides comprehensive IAM Single Sign-On (SSO) management in AWS

 It creates and manages:

 - Permission sets with customizable session durations
 - Managed policy attachments for permission sets
 - Account assignments for SSO users
 - Access analysis through IAM Access Analyzer
 - Audit logging via CloudTrail
 - Environment-specific service control policies
 
 The module supports multiple environments (prod, staging, dev) with appropriate security restrictions and monitoring capabilities.


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
