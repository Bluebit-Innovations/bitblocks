module "kms_basic" {
  source                 = "../../sec_kms"
  alias_name             = "basic-key"
  key_description        = "A simple KMS key"
  enable_key_rotation    = true
}
