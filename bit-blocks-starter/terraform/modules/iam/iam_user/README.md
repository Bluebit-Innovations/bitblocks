# AWS IAM User Module

This Terraform module creates IAM users with specified permissions and group memberships.This Terraform module creates and manages AWS users with comprehensive security features:

 - Creates IAM users with configurable paths
 - Manages user login profiles with PGP-encrypted passwords
 - Creates access keys (optionally PGP-encrypted)
 - Handles group memberships
 - Implements security monitoring through IAM Access Analyzer
 - Enables CloudTrail logging with S3 bucket storage
 - Enforces environment-specific restrictions via Service Control Policies
 

## Features

- Create IAM users with custom usernames
- Generate access keys (optional)
- Force password reset on first login
- Add users to multiple IAM groups
- Attach direct IAM roles (For only special cases only)
- Enables Access Analyzer and CloudTrail for the user.

## Usage

Basic example:

```hcl
module "iam_user" {
    source = "./terraform-modules/iam/iam_user"

    username = "john.doe"
    groups   = ["developers", "testers"]
    
    create_login_profile = true
    create_access_key = true
    force_password_change = true
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| username | Name of the IAM user | `string` | n/a | yes |
| groups | List of IAM groups to add user to | `list(string)` | `[]` | no |
| policy_arns | List of policy ARNs to attach to user | `list(string)` | `[]` | no |
| generate_credentials | Whether to generate access keys | `bool` | `false` | no |
| force_password_change | Require password change on first login | `bool` | `true` | no |
| password_length | Length of generated password | `number` | `16` | no |

## Outputs

| Name | Description |
|------|-------------|
| user_arn | ARN of the IAM user |
| access_key_id | Access key ID (if generated) |
| secret_access_key | Secret access key (if generated) |



# Key Features:
 - Secure password and access key management
 - Comprehensive audit logging
 - Environment-specific security controls
 - Multi-region monitoring support