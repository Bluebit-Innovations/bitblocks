module "tag_governance_advanced" {
  source                 = "../../gov_tagging"
  tag_policy_name        = "enforce-core-tags"
  tag_policy_description = "Strict org-wide tagging policy"
  target_ou_id           = "ou-abcd-12345678"
  enable_sns_alerts      = true
  config_resource_types  = ["AWS::EC2::Instance", "AWS::S3::Bucket", "AWS::RDS::DBInstance"]
}
