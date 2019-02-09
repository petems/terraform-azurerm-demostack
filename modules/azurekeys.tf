resource "random_id" "keyvault" {
  byte_length = 4
}

resource "random_id" "keyvaultkey" {
  byte_length = 4
}

resource "azurerm_key_vault" "vaultstack" {
  name                        = "vaultstack-${random_id.keyvault.hex}"
  location                    = "${azurerm_resource_group.vaultstack.location}"
  resource_group_name         = "${azurerm_resource_group.vaultstack.name}"
  enabled_for_deployment      = true
  enabled_for_disk_encryption = true
  tenant_id                   = "${var.tenant}"

  sku {
    name = "standard"
  }

  tags {
    name      = "Peter Souter"
    ttl       = "13"
    owner     = "psouter@hashicorp.com"
    vaultstack = "${local.consul_join_tag_value}"
  }
}

resource "azurerm_user_assigned_identity" "vaultstack" {
  resource_group_name = "${azurerm_resource_group.vaultstack.name}"
  location            = "${azurerm_resource_group.vaultstack.location}"

  name = "${var.hostname}-vaultstack-vm"
}

resource "azurerm_key_vault_access_policy" "vaultstack_vm" {
  vault_name          = "${azurerm_key_vault.vaultstack.name}"
  resource_group_name = "${azurerm_key_vault.vaultstack.resource_group_name}"

  tenant_id = "${var.tenant}"
  object_id = "${azurerm_user_assigned_identity.vaultstack.principal_id}"

  certificate_permissions = [
    "get",
    "list",
    "create",
  ]
  key_permissions = [
    "backup",
    "create",
    "decrypt",
    "delete",
    "encrypt",
    "get",
    "import",
    "list",
    "purge",
    "recover",
    "restore",
    "sign",
    "unwrapKey",
    "update",
    "verify",
    "wrapKey",
  ]
  secret_permissions = [
    "get",
    "list",
    "set",
  ]
}

resource "azurerm_key_vault_key" "vaultstack" {
  name      = "vaultstack-${random_id.keyvaultkey.hex}"
  vault_uri = "${azurerm_key_vault.vaultstack.vault_uri}"
  key_type  = "RSA"
  key_size  = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  tags {
    name      = "Peter Souter"
    ttl       = "13"
    owner     = "psouter@hashicorp.com"
    vaultstack = "${local.consul_join_tag_value}"
  }
}
