

resource "azurerm_application_gateway" "network" {
  name                = "${local.prefix}-gateway"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "${local.prefix}-gateway-ip-configuration"
    subnet_id = azurerm_subnet.this.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.this.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  dynamic "backend_http_settings" {
    for_each = { for backend_http_setting in local.backend_http_settings : backend_http_setting.name => backend_http_setting }

    content {
      name                  = backend_http_settings.value.name
      cookie_based_affinity = try(backend_http_settings.value.affinity_cookie_name, "Disabled")
      path                  = backend_http_settings.value.path
      port                  = try(backend_http_settings.value.port, 80)
      protocol              = "Http"
      request_timeout       = 60
    }
  }

  dynamic "http_listener" {
    for_each = { for http_listener in local.http_listeners : http_listener.name => http_listener }

    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = local.frontend_port_name
      protocol                       = "Http"
    }
  }

  dynamic "request_routing_rule" {
    for_each = { for request_routing_rule in local.request_routing_rules : request_routing_rule.name => request_routing_rule }
    content {
      name                       = request_routing_rule.value.name
      priority                   = request_routing_rule.value.priority
      rule_type                  = "Basic"
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
    }
  }

  lifecycle {
    ignore_changes = [
      ## can add properties which will conflict with AGIC
     ]
  }
}
