module "gov_scp_inline" {
  source = "../../../gov_scp"

  allowed_environments = ["prod", "dev"]

  scp_policies = [
    {
      name            = "deny-s3-delete"
      description     = "Deny all S3 delete actions"
      policy_inline   = jsonencode({
        Version = "2012-10-17",
        Statement = [{
          Effect   = "Deny",
          Action   = [
            "s3:DeleteObject",
            "s3:DeleteBucket"
          ],
          Resource = "*"
        }]
      })
      use_policy_file = false
      target_ids      = ["ou-abc1-12345678"]
      enabled         = true
      environment     = "prod"
      tags            = {
        Owner     = "cloudops"
        ManagedBy = "Terraform"
      }
    }
  ]
}
