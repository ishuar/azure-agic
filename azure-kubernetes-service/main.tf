## Network
data "azurerm_resource_group" "this" {
  name = "${local.prefix}-rg"
}

data "azurerm_virtual_network" "this" {
  name                = "${local.prefix}-network"
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  name                 = "${local.prefix}-aks-subnet"
  resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.this.name
  address_prefixes     = ["10.254.1.0/24"]
}

data "azurerm_application_gateway" "this" {
  name                = "${local.prefix}-gateway"
  resource_group_name = data.azurerm_resource_group.this.name
}

## SSH Key Generator
module "ssh_key_generator" {
  source               = "github.com/ishuar/terraform-sshkey-generator?ref=v1.1.0"
  algorithm            = "RSA"
  private_key_filename = "${path.module}/aks-private-key"
  file_permission      = "600"
}

## Azure Kubernetes Cluster
module "aks" {
  source  = "ishuar/aks/azure"
  version = "~> 2.3"

  location                     = data.azurerm_virtual_network.this.location
  resource_group_name          = data.azurerm_virtual_network.this.resource_group_name
  name                         = "${local.prefix}-cluster"
  dns_prefix                   = local.prefix
  default_node_pool_name       = "default"
  default_node_pool_node_count = 1
  key_data                     = trimspace(module.ssh_key_generator.public_ssh_key)

  ## Networking
  vnet_subnet_id      = azurerm_subnet.this.id
  network_plugin      = "azure"
  network_plugin_mode = null
  network_policy      = "azure"

  # ## Application Gateway
  # ingress_app_gw_enabled = true
  # ingress_app_gw_id      = data.azurerm_application_gateway.this.id
  ingress_app_gw_enabled = false

  ## Flux
  enable_fluxcd                      = true
  fluxcd_extension_name              = "fluxcd-001"
  fluxcd_configuration_name          = local.prefix
  fluxcd_extension_release_namespace = "flux-system"
  fluxcd_namespace                   = "flux"
  fluxcd_scope                       = "cluster"
  fluxcd_git_repository_url          = "https://github.com/ishuar/kubernetes-in-real-life"
  fluxcd_extension_configuration_settings = {
    "multiTenancy.enforce" = false
  }

  kustomizations = [
    {
      name                     = "sources"
      path                     = "./azure-kubernetes-service/gitops/fluxcd/sources"
      sync_interval_in_seconds = 60
      recreating_enabled       = true
    },
    {
      name                     = "azure-ingress-agic"
      path                     = "./azure-kubernetes-service/gitops/fluxcd/application-gateway-ingress-controller"
      sync_interval_in_seconds = 10
      recreating_enabled       = true
      depends_on               = ["sources"]
    },
  ]

  ## Workload Identity
  oidc_issuer_enabled       = true
  workload_identity_enabled = true


  ### This is experimental only Feature
  enable_fluxcd_az_providers = true
}

