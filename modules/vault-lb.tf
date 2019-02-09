# Create Public IP Address for the Load Balancer
resource "azurerm_public_ip" "lb" {
  count               = 1
  name                = "${var.resource_group}-pubip"
  resource_group_name = "${azurerm_resource_group.vaultstack.name}"
  location            = "${var.location}"
  allocation_method   = "Static"
  domain_name_label   = "${var.hostname}-lb-${count.index}"
  sku                 = "Standard"

  tags {
    name      = "Peter Souter"
    ttl       = "13"
    owner     = "psouter@hashicorp.com"
    vaultstack = "${local.consul_join_tag_value}"
  }
}

# create and configure Azure Load Balancer

resource "azurerm_lb" "lb" {
  name                = "${var.resource_group}-lb"
  resource_group_name = "${azurerm_resource_group.vaultstack.name}"
  location            = "${var.location}"
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "${var.resource_group}-frontendip"
    public_ip_address_id = "${azurerm_public_ip.lb.id}"
  }

  tags {
    name      = "Peter Souter"
    ttl       = "13"
    owner     = "psouter@hashicorp.com"
    vaultstack = "${local.consul_join_tag_value}"
  }
}

resource "azurerm_lb_probe" "lb" {
  name                = "${var.resource_group}-probe"
  resource_group_name = "${azurerm_resource_group.vaultstack.name}"
  loadbalancer_id     = "${azurerm_lb.lb.id}"
  protocol            = "https"
  port                = "8200"
  request_path        = "/v1/sys/health"
  number_of_probes    = "1"
}

resource "azurerm_lb_rule" "lb" {
  name                           = "${var.resource_group}-lbrule"
  resource_group_name            = "${azurerm_resource_group.vaultstack.name}"
  loadbalancer_id                = "${azurerm_lb.lb.id}"
  protocol                       = "Tcp"
  frontend_port                  = "80"
  backend_port                   = "8200"
  frontend_ip_configuration_name = "${var.resource_group}-frontendip"
  probe_id                       = "${azurerm_lb_probe.lb.id}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.lb.id}"
  depends_on                     = ["azurerm_lb_probe.lb", "azurerm_lb_backend_address_pool.lb"]
}

resource "azurerm_lb_backend_address_pool" "lb" {
  name                = "${var.resource_group}-bck-pool"
  resource_group_name = "${azurerm_resource_group.vaultstack.name}"
  loadbalancer_id     = "${azurerm_lb.lb.id}"
}
