## Introduction

Deploy Application gateway ingress controller (AGIC) and expose a sample application. Use workload Identity for AGIC to avoid Static and long term credentials.

Sample app is reachable at http://40.68.167.160/

> used one of my deployments was lazy to write some k8s manifests 🥲

## Considerations

1. APP Gw Requires a dedicated subnet with no other resources.
2. Helm Deployment over Add On for more customizations.
3. Workload Idenity over service principal
4. Use `lifecycle.ignore_changes` to avoid conflict between terraform and AGIC on application gateway deployment with terraform.
5. Refer to [agic_resource_permissions_map](./azure-kubernetes-service/local.tf) for minimum permissions needed by AGIC.

## Known Issues

1. AGIC does not support Azure CNI Overlay Mode, ref: [Limitations with Azure CNI](https://learn.microsoft.com/en-us/azure/aks/azure-cni-overlay?tabs=kubectl#limitations-with-azure-cni-overlay)
2. Known Issues which may impact us:
   1. [SSL Certificates are not pruned by AGIC](https://github.com/Azure/application-gateway-kubernetes-ingress/issues/1488)
   2. [Community thoughs on AGIC](https://github.com/Azure/application-gateway-kubernetes-ingress/issues/725)
   3. Soon Deprecation from Azure

3. Could be cost intesive but not a deal breaker for us as per discussions.