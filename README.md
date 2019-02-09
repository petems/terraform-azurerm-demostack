# terraform-azurerm-vaultstack

Forked from terraform-azurerm-meanstack

Creates a Vault and Consul stack within Azure

NOT SUITABLE FOR PROD USE WITHOUT EDITING

## Current Reasons Why Not Used For Production

* Servers install both Vault and Consul - Needs to be split into seperate Consul (x5) and Vault (x3) servers
* Vault root key and token are stored in plaintext in Consul

For that reason, it will only allow access from the IP of the instance that Terraform is running from:

```hcl
data "http" "current_ip" {
  url = "http://ipv4.icanhazip.com"
}

security_rule {
  name                       = "vaultstack-run"
  priority                   = 104
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "8000-8800"
  source_address_prefix      = "${chomp(data.http.current_ip.body)}/32"
  destination_address_prefix = "*"
}
```

This can obviously edited to either run the Vault initizliation commands outside of the script if needed.
