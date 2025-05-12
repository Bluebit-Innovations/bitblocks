# IAM Service Account Module

This Terraform module creates an IAM service account for use with GitHub Actions, other CI/CD systems or applications that require service accounts for access cloud resources.

This Terraform module creates and manages AWS IAM roles with comprehensive security features including:


 - IAM role creation with configurable assume role policies
 - AWS managed policy attachments
 - AWS SSO permission set integration
 - Security monitoring via IAM Access Analyzer
 - Audit logging through CloudTrail
 - Environment-specific service control policies
 - Designed for secure and compliant access management across different environments.

## Usage

To use this module in your Terraform configuration:

```hcl
module "iam_service_account" {
    source = "./terraform-modules/iam/iam_service_account"
    
    name        = "github-actions"
    description = "Service account for GitHub Actions"
    
    # Optional: Attach AWS managed policies
    policy_arns = [
        "arn:aws:iam::aws:policy/ReadOnlyAccess"
    ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| service_account_name | Name of the service account | `string` | n/a | yes |
| assume_role_policy | JSON policy for service account assume role | `string` | n/a | yes |
| service_account_policy_arns | List of ARNs of the IAM policies to attach to the service account role | `list(string)` | n/a | yes |
| create_sso_permission_set | Whether to create an AWS SSO permission set for the service account | `bool` | `false` | no |
| sso_instance_arn | ARN of the AWS SSO instance | `string` | `null` | no |
| service_account_description | Description of the service account | `string` | `null` | no |
| ssoadmin_permission_set_name | Name of the AWS SSO permission set | `string` | `null` | no |
| ssoadmin_permission_set_description | Description of the AWS SSO permission set | `string` | `null` | no |


## Outputs

| Name | Description |
|------|-------------|
| service_account_arn | The ARN of the service account |
| service_account_name | The name of the service account |
| service_account_create_date | The creation date of the service account |
| service_account_policy_arns | The list of ARNs of the IAM policies attached to the service account role |
| service_account_sso_permission_set_arn | The ARN of the AWS SSO permission set for the service account |
| service_account_sso_permission_set_name | The name of the AWS SSO permission set for the service account |
| service_account_sso_permission_set_description | The description of the AWS SSO permission set for the service account |
| service_account_sso_permission_set_session_duration | The session duration of the AWS SSO permission set for the service account |
| service_account_sso_permission_set_managed_policy_arns | The list of ARNs of the managed policies attached to the AWS SSO permission set for the service account |
| service_account_sso_permission_set_instance_arn | The ARN of the AWS SSO instance for the AWS SSO permission set for the service account |
