// If you wish to create the tls_root_certs, you can fetch the data from the local directory
data "terraform_remote_state" "tls_terraform_certs" {
  backend = "local"

  config {
    path = "${path.module}/tls_certificates/terraform.tfstate"
  }
}

// If you've created them outside of Terraform: - WIP
// data "local_file" "cert" {
//   filename = "${path.module}/tls.cert"
// }

module "primarycluster" {
  source              = "./modules"
  resource_group      = "${var.resource_group}"
  hostname            = "${var.hostname}"
  location            = "${var.location}"
  admin_username      = "${var.admin_username}"
  admin_password      = "${var.admin_password}"
  subscription        = "${var.subscription}"
  tenant              = "${var.tenant}"
  client_id           = "${var.client_id}"
  client_secret       = "${var.client_secret}"
  owner               = "${var.owner}"
  public_key          = "${var.public_key}"
  servers             = "${var.servers}"
  consul_url          = "${var.consul_url}"
  vault_url           = "${var.vault_url}"
  created-by          = "${var.created-by}"
  sleep-at-night      = "${var.sleep-at-night}"
  TTL                 = "${var.TTL}"
  ca_key_algorithm    = "${data.terraform_remote_state.tls_terraform_certs.ca_key_algorithm}"
  ca_private_key_pem  = "${data.terraform_remote_state.tls_terraform_certs.ca_private_key_pem}"
  ca_cert_pem         = "${data.terraform_remote_state.tls_terraform_certs.ca_cert_pem}"

  // If creating outside of Terraform - WIP
  // ca_key_algorithm    = "${data.local_file.cert.ca_key_algorithm}"
  // ca_private_key_pem  = "${data.local_file.cert.ca_private_key_pem}"
  // ca_cert_pem         = "${data.local_file.cert.ca_cert_pem}"
}
