# Root private key
resource "tls_private_key" "root" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

# Root certificate
resource "tls_self_signed_cert" "root" {
  key_algorithm   = "${tls_private_key.root.algorithm}"
  private_key_pem = "${tls_private_key.root.private_key_pem}"

  subject {
    common_name  = "service.consul"
    organization = "service.consul"
  }

  validity_period_hours = "720"

  allowed_uses = [
    "cert_signing",
    "crl_signing",
    "servers_auth",
  ]

  is_ca_certificate = true
}

output "ca_key_algorithm" {
  value = "${tls_private_key.root.algorithm}"
}

output "ca_private_key_pem" {
  value = "${tls_private_key.root.private_key_pem}"
}

output "ca_cert_pem" {
  value = "${tls_self_signed_cert.root.cert_pem}"
}
