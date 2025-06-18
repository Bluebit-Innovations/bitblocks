# Simple Advanced example of using the gov_scp module
module "gov_scp_advanced" {
  source = "../../gov_scp"

  allowed_environments = ["prod", "staging"]

  scp_policies = [
    {
      name           = "deny-ec2"
      description    = "Deny EC2 usage"
      policy_content = jsonencode({
        Version = "2012-10-17",
        Statement = [{
          Effect   = "Deny",
          Action   = "ec2:*",
          Resource = "*"
        }]
      })
      tags        = { ManagedBy = "Terraform" }
      target_ids  = ["ou-abc1-12345678"]
      enabled     = true
      environment = "prod"
    },
    {
      name           = "deny-cloudshell"
      description    = "Prevent CloudShell"
      policy_content = jsonencode({
        Version = "2012-10-17",
        Statement = [{
          Effect   = "Deny",
          Action   = "cloudshell:*",
          Resource = "*"
        }]
      })
      target_ids  = ["ou-abc2-87654321"]
      enabled     = true
      environment = "staging"
    }
  ]
}


# Full Advanced example of using the gov_scp module

module "gov_scp_advanced_full" {
  source = "../../gov_scp"

  allowed_environments = ["dev", "staging", "prod"]

  scp_policies = [
    {
      name           = "deny-ec2"
      description    = "Deny EC2 access"
      policy_content = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Sid      = "DenyEC2",
            Effect   = "Deny",
            Action   = "ec2:*",
            Resource = "*"
          }
        ]
      })
      target_ids  = ["ou-dev1-12345678"]
      tags        = { Environment = "dev", Owner = "cloud-team" }
      enabled     = true
      environment = "dev"
    },
    {
      name           = "deny-cloudshell"
      description    = "Block AWS CloudShell usage"
      policy_content = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Sid      = "DenyCloudShell",
            Effect   = "Deny",
            Action   = "cloudshell:*",
            Resource = "*"
          }
        ]
      })
      target_ids  = ["ou-prod1-87654321"]
      tags        = { Environment = "prod", Owner = "security" }
      enabled     = true
      environment = "prod"
    },
    {
      name           = "deny-s3-logging"
      description    = "Temporarily block S3 logging"
      policy_content = jsonencode({
        Version = "2012-10-17",
        Statement = [
          {
            Sid      = "DenyS3Logging",
            Effect   = "Deny",
            Action   = [
              "s3:PutBucketLogging",
              "s3:PutBucketAcl"
            ],
            Resource = "*"
          }
        ]
      })
      target_ids  = ["ou-stg1-45678901"]
      tags        = { Environment = "staging" }
      enabled     = false  # not deployed
      environment = "staging"
    }
  ]
}
