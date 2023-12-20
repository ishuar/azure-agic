locals {
  prefix = "agic-poc"
  tags = {
    type       = "aks-module"
    managed_by = "terraform"
  }
  agic_resource_permissions_map = {
    "${data.azurerm_resource_group.this.id}"                                        = "Reader"
    "${data.azurerm_application_gateway.this.id}"                                   = "Contributor"
    "${data.azurerm_application_gateway.this.gateway_ip_configuration.0.subnet_id}" = "Network Contributor"
  }
}
