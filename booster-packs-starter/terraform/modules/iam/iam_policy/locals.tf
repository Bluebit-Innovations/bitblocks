# Environment-specific variables validation
locals {
    valid_environments = ["dev", "staging", "prod"]
    environment = contains(local.valid_environments, var.environment) ? var.environment : "dev"
    
    default_tags = merge({
        Environment = local.environment
        ManagedBy   = "terraform"
        Module      = "iam-group"
    }, var.tags)

    # Define environment-specific restrictions
    prod_restrictions    = [
        "iam:DeletePolicy",
        "iam:DeletePolicyVersion",
        "iam:DeleteUserPolicy",
        "iam:DeleteRolePolicy",
        "iam:DeleteGroupPolicy"
    ]
    staging_restrictions = [
        "iam:DeletePolicy",
        "iam:DeletePolicyVersion"
    ]
    dev_restrictions    = [
        "iam:DeletePolicy"
    ]

    # Environment-specific restrictions
    restrictions = concat(
        var.environment == "prod" ? local.prod_restrictions : [],
        var.environment == "staging" ? local.staging_restrictions : [],
        var.environment == "dev" ? local.dev_restrictions : []
    )
}

