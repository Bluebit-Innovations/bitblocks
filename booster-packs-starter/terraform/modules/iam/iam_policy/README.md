# Module: IAM Policy Terraform Module

This module creates and manages AWS IAM policies with comprehensive security controls including:
 - IAM policy creation and attachments to groups, users, and roles
 - SSO integration for permission set policy attachments
 - Security monitoring through IAM Access Analyzer
 - Audit logging via CloudTrail
 - Environment-specific service control policies

## Usage

```hcl
module "iam_policy" {
    source = "./terraform-modules/iam/iam_policy"
    
    name        = "example-policy"
    path        = "/"
    description = "Example policy for demonstration"
    policy      = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "s3:ListBucket"
                ]
                Resource = [
                    "arn:aws:s3:::example-bucket"
                ]
            }
        ]
    })
}
```

## Input Variables

| Name | Description | Type | Required | Default |
|------|-------------|------|----------|---------|
| name | The name of the policy | string | yes | - |
| path | The path of the policy | string | no | "/" |
| description | The description of the policy | string | yes | - |
| policy | The policy document | string | yes | - |
| groups | The list of IAM groups to attach the policy to | list(string) | no | [] |
| users | The list of IAM users to attach the policy to | list(string) | no | [] |
| roles | The list of IAM roles to attach the policy to | list(string) | no | [] |
| enable_sso | Flag to enable/disable SSO resources | bool | no | false |
| permission_set_arn | The ARN of the permission set | string | yes | - |
| principal_arn | The ARN of the principal | string | yes | - |

## Outputs

| Name | Description |
|------|-------------|
| policy_id | The unique identifier assigned by AWS for the policy |
| policy_arn | The Amazon Resource Name (ARN) assigned by AWS to this policy |
| policy_name | The name specified for the created IAM policy |
| policy_path | The path of the policy in IAM |
| sso_managed_policy_id | The ID of the SSO managed policy (if SSO is enabled) |
