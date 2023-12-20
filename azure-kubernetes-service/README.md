## Introduction

Deploy AGIC and expose a sample application. Use workload Identity for AGIC to avoid Static and long term credentials.

Sample app is reachable at http://40.68.167.160/

> used one of my deployments was lazy to write some k8s manifests 🥲

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.85 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.85.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | ishuar/aks/azure | ~> 2.3 |
| <a name="module_ssh_key_generator"></a> [ssh\_key\_generator](#module\_ssh\_key\_generator) | github.com/ishuar/terraform-sshkey-generator | v1.1.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_federated_identity_credential.agic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential) | resource |
| [azurerm_role_assignment.agic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_user_assigned_identity.agic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_application_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_gateway) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agic-client-id"></a> [agic-client-id](#output\_agic-client-id) | Client ID used in workload Identity for AGIC service account. |
