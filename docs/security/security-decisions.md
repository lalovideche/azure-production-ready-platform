# Security Decisions

## Overview

The Azure Production-Ready Platform follows a private-by-default design for application dependencies and avoids storing long-lived credentials in GitHub or application configuration.

The main security objectives are:

- Prevent direct public access to the backend and data services.
- Avoid Azure client secrets in GitHub Actions.
- Use workload identities instead of passwords or access keys.
- Apply least-privilege Azure RBAC permissions.
- Protect the source repository and deployment workflow.
- Maintain traceability between source code, container images and deployments.

## Threat model

The project considers the following primary risks:

| Risk | Security control |
|---|---|
| Unauthorized access to the backend | Public access disabled and Private Endpoint enabled |
| Unauthorized access to Storage | Public network access disabled and Private Endpoint enabled |
| Unauthorized access to Key Vault | Public network access disabled and Private Endpoint enabled |
| Credential leakage from GitHub | GitHub Actions authenticates through OIDC |
| Application secrets committed to source control | `.gitignore`, Secret Protection and Push Protection |
| Container registry password exposure | ACR administrator credentials disabled |
| Unauthorized image downloads | App Services use Managed Identity and `AcrPull` RBAC |
| Excessive permissions | Separate role assignments with least-privilege roles |
| Untraceable deployments | Container images are tagged with the Git commit SHA |
| Direct modification of `main` | Pull Requests and repository ruleset protection |
| Infrastructure configuration drift | Terraform planning and drift detection |
| Loss of operational visibility | Application Insights, Log Analytics and diagnostic settings |

## Identity and authentication

### GitHub Actions to Azure

GitHub Actions uses OpenID Connect federation to authenticate to Azure.

This design avoids storing a long-lived Azure client secret in GitHub.

Authentication flow:

1. GitHub Actions requests an OIDC token.
2. Microsoft Entra ID validates the federated identity.
3. Azure issues a temporary access token.
4. The workflow uses the token to access the Azure subscription.

Security benefits:

- No `AZURE_CLIENT_SECRET`.
- Short-lived tokens.
- Trust is restricted to the expected GitHub repository and workflow context.
- Credentials do not need to be manually rotated.

### Application Managed Identities

The frontend and backend use separate user-assigned managed identities.

The frontend identity is used to:

- Pull the frontend image from Azure Container Registry.

The backend identity is used to:

- Pull the backend image from Azure Container Registry.
- Read secrets from Azure Key Vault.
- Read and write messages in Azure Blob Storage.

The identities are kept separate so permissions can be assigned independently.

## Azure RBAC

The following least-privilege role assignments are used:

| Workload | Scope | Role |
|---|---|---|
| Frontend Managed Identity | Azure Container Registry | `AcrPull` |
| Backend Managed Identity | Azure Container Registry | `AcrPull` |
| Backend Managed Identity | Storage Account | `Storage Blob Data Contributor` |
| Backend Managed Identity | Key Vault | `Key Vault Secrets User` |

The application does not use:

- ACR administrator credentials.
- Storage Account access keys.
- Key Vault access policies containing embedded application credentials.
- Azure client secrets.

## Network security

### Public frontend

The frontend is the only application component intended to receive public traffic.

Controls:

- HTTPS-only access.
- Minimum TLS version configured.
- Public access enabled only for the frontend.
- Application traffic to dependencies uses private connectivity.

### Private backend

The backend has public network access disabled.

The frontend reaches it through:

- VNet integration.
- Azure Private Link.
- A backend Private Endpoint.
- A Private DNS Zone for Azure Web Apps.

A direct request from the public internet to the backend is expected to return:

```text
HTTP 403 Ip Forbidden