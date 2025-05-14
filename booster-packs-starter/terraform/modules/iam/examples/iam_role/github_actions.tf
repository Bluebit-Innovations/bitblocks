module "github_actions_role" {
  source = "../../iam_role"

  name = "github-deploy-role"
  path = "/"
  tags = {
    Owner       = "bluebit"
    Environment = "staging"
  }

    assume_role_principal_type        = "Federated"
    assume_role_principal_identifiers = [
    "arn:aws:iam::123456789012:oidc-provider/token.actions.githubusercontent.com"
    ]

    assume_role_conditions = [
    {
        test     = "StringEquals"
        variable = "token.actions.githubusercontent.com:sub"
        values   = ["repo:bluebit/myrepo:*"]
    }
    ]

  inline_policies = [
    {
      name   = "github-actions-deploy"
      policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Effect   = "Allow",
            Action   = ["s3:*", "cloudfront:CreateInvalidation"],
            Resource = "*"
          }
        ]
      })
    }
  ]

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ]
}

data "aws_caller_identity" "current" {}
