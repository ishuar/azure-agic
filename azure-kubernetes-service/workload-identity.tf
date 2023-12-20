resource "azurerm_user_assigned_identity" "agic" {
  location            = data.azurerm_resource_group.this.location
  name                = "${local.prefix}-uid"
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_federated_identity_credential" "agic" {
  name                = "federated-${local.prefix}"
  resource_group_name = data.azurerm_resource_group.this.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks.azurerm_kubernetes_cluster.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.agic.id
  subject             = "system:serviceaccount:flux:ingress-azure"
}

resource "azurerm_role_assignment" "agic" {
  for_each             = local.agic_resource_permissions_map
  scope                = each.key
  role_definition_name = each.value
  principal_id         = azurerm_user_assigned_identity.agic.principal_id
}
