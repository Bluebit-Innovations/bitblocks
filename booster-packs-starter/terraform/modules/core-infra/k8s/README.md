# Terraform Modules for Automated AWS Infrastructure deployment

This repository contains reusable Terraform modules for provisioning and managing AWS infrastructure components.

## Structure

The modules are organized by functionality and AWS service. Each module is designed to be self-contained and reusable across different projects.

## Usage

To use any module in this repository:

1. Reference the module in your Terraform configuration:

```hcl
module "billing" {
    source = "./terraform-modules/billing"
    # configuration variables
}

module "iam" {
    source = "./terraform-modules/iam"
    # configuration variables
}

module "core-infra" {
    source = "./terraform-modules/core-infra"
    # configuration variables
}

module "governance" {
    source = "./terraform-modules/governance"
    # configuration variables
}

module "security" {
    source = "./terraform-modules/security"
    # configuration variables
}
```


2. Example using IAM sub-modules:

```hcl
# Using the IAM User sub-module
module "iam_user" {
    source = "./terraform-modules/iam/iam_user"
    username = "example-user"
    groups = ["developers"]
}

# Using the IAM Group sub-module
module "iam_group" {
    source = "./terraform-modules/iam/iam_group"
    group_name = "developers"
    policy_arns = [
        "arn:aws:iam::aws:policy/ReadOnlyAccess"
    ]
}
```

Each sub-module can be used independently or together as needed.