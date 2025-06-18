module "sec_network_baseline_advanced" {
  source = "../../sec_network_baseline"  # Adjust based on your folder structure

  vpc_id                  = "vpc-0123abc456def7890"
  default_network_acl_id = "acl-01ab23cd456efg789"

  name_prefix                 = "core-network"
  enable_flow_logs            = true
  flow_log_destination_type   = "s3"
  flow_log_retention_days     = 90
  prevent_public_subnet_access = true
}
