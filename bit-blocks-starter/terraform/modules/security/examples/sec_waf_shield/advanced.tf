module "waf_shield_advanced" {
  source = "../../sec_waf_shield" # Adjust path as needed

  web_acl_name              = "bluebit-advanced-waf"
  scope                     = "REGIONAL"
  resource_arn              = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/advanced-app/50dc6c495c0c9188"
  enable_shield_protection  = true
  enable_protection_group   = true
  shield_group_name         = "bluebit-critical-apps"
  shield_group_members      = [
    "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/app1/50dc6c495c0c9188",
    "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/app2/60ec7c395d1d9289"
  ]

  tags = {
    Project     = "bluebit"
    Environment = "production"
    Owner       = "security-team"
  }
}
