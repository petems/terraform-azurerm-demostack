module "rootcertificate" {
  source                = "github.com/GuyBarros/terraform-tls-certificate"
  version               = "0.0.1"
  algorithm             = "ECDSA"
  ecdsa_curve           = "P521"
  common_name           = "service.consul"
  organization          = "service.consul"
  validity_period_hours = 720
  is_ca_certificate     = true
}
