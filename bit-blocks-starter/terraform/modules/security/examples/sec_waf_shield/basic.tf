
module "waf_shield_basic" {
  source = "../../sec_waf_shield" # Adjust path as needed

  web_acl_name = "bluebit-basic-waf"
  scope        = "REGIONAL"
  resource_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/my-app/50dc6c495c0c9188"
}
