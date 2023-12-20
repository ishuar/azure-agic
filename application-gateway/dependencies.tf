resource "azurerm_resource_group" "this" {
  name     = "${local.prefix}-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "this" {
  name                = "${local.prefix}-network"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = ["10.254.0.0/16"]
}

resource "azurerm_subnet" "this" {
  name                 = "${local.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.254.0.0/28"]
}

resource "azurerm_public_ip" "this" {
  name                = "${local.prefix}-pip"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"
  sku                 = "Standard"
}
