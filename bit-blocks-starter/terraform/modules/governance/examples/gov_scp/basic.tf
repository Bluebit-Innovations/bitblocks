module "gov_scp_basic" {
  source = "../../gov_scp"

  scp_policies = [
    {
      name           = "deny-root-actions"
      description    = "Prevent use of root user"
      policy_content = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Sid      = "DenyRootActions",
            Effect   = "Deny",
            Action   = "*",
            Resource = "*",
            Condition = {
              StringEquals = {
                "aws:PrincipalAccount" = "123456789012"
              }
            }
          }
        ]
      })
      target_ids  = ["ou-xyz1-abc12345"]
      enabled     = true
      environment = "prod"
    }
  ]
}
