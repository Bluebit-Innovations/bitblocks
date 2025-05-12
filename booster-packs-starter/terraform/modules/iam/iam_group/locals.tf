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
    global_restrictions    = [
        "iam:DeleteUser",
        "iam:DeleteUserPolicy",
        "iam:DeleteGroup",
        "iam:DeleteGroupPolicy"
    ]
    prod_restrictions    = [
        "iam:DeleteUser",
        "iam:DeleteUserPolicy",
        "iam:DeleteGroup",
        "iam:DeleteGroupPolicy"
    ]
    staging_restrictions = [
        "iam:DeleteGroup",
        "iam:DeleteGroupPolicy"
    ]
    dev_restrictions    = [
        "iam:DeleteGroup"
    ]

    # Environment-specific restrictions
    restrictions = concat(
        var.environment == "global" ? local.global_restrictions : [],
        var.environment == "prod" ? local.prod_restrictions : [],
        var.environment == "staging" ? local.staging_restrictions : [],
        var.environment == "dev" ? local.dev_restrictions : []
    )
}

