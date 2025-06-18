module "gov_scp_file" {
  source = "../../../gov_scp"

  allowed_environments = ["prod", "dev", "staging"]

  scp_policies = [
    {
      name             = "deny-ec2"
      description      = "Block EC2 usage across the org"
      policy_file_path = "policies/deny-ec2.json"
      use_policy_file  = true
      target_ids       = ["ou-prod-87654321"]
      enabled          = true
      environment      = "prod"
      tags             = {
        Owner     = "security"
        ManagedBy = "Terraform"
      }
    }
  ]
}
