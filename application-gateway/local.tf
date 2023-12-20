# since these variables are re-used - a locals block makes this more maintainable
locals {
  prefix                         = "agic-poc"
  frontend_port_name             = "http-feport"
  frontend_ip_configuration_name = "${local.prefix}-feip"
  backend_address_pool_name      = "${local.prefix}-backend-address-pool-01"

  /*
  These configs are just for example , there is no backend serving them hence no listerner is working for them.
  This is just to demonstrate the plan diff for application gateway resource.
  */

  ### BACKEND HTTP SETTINGS ###
  backend_http_settings = [
    {
      name = "${local.prefix}-backend-http-setting-01"
      path = "/path1/"
    },
    # {
    #   name = "${local.prefix}-backend-http-setting-02"
    #   path = "/path2/"
    # }
  ]

  ### HTTP LISTENER ###
  http_listeners = [
    {
      name = "${local.prefix}-http-listener-01"
    },
    # {
    #   name = "${local.prefix}-http-listener-02"
    # }
  ]
  ## REQUEST ROUTING RULES ###
  request_routing_rules = [
    {
      name                       = "${local.prefix}-request-routing-rule-01"
      priority                   = 1
      http_listener_name         = local.http_listeners[0].name
      backend_address_pool_name  = local.backend_address_pool_name
      backend_http_settings_name = local.backend_http_settings[0].name
    },
    # {
    #   name                       = "${local.prefix}-request-routing-rule-02"
    #   priority                   = 2
    #   http_listener_name         = local.http_listeners[1].name
    #   backend_address_pool_name  = local.backend_address_pool_name
    #   backend_http_settings_name = local.backend_http_settings[1].name
    # }
  ]
}
