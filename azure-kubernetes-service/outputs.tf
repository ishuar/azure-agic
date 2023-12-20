output "agic-client-id" {
  value       = azurerm_user_assigned_identity.agic.client_id
  description = "Client ID used in workload Identity for AGIC service account."
}
