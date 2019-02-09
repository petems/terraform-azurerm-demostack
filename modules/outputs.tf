output "servers" {
  value = "${formatlist("http://%s:8500/", azurerm_public_ip.servers-pip.*.fqdn,)}"
}

output "service_identity_principal_id" {
  value = "${azurerm_user_assigned_identity.vaultstack.principal_id}"
}

output "key_vault_name" {
  value = "${azurerm_key_vault.vaultstack.name}"
}
