module "sec_network_baseline_basic" {
  source = "../../sec_network_baseline"  # Adjust based on your folder structure

  vpc_id                  = "vpc-0a12b3456cdef7890"
  default_network_acl_id = "acl-012abc345def678gh"

  name_prefix = "prod-network"
}
