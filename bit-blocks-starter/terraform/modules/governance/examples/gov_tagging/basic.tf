module "tag_governance_basic" {
  source                 = "../../gov_tagging"
  tag_policy_name        = "enforce-core-tags"
  tag_policy_description = "Ensure all resources have Environment and Owner tags"
  target_ou_id           = "ou-abcd-12345678"
}
