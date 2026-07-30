# Azure Production-Ready Platform

A production-oriented Azure portfolio project that deploys a containerized frontend and backend using Terraform, GitHub Actions and secure Azure-native identity and networking controls.

The project demonstrates Infrastructure as Code, CI/CD, private connectivity, Managed Identity, Azure RBAC, monitoring, drift detection and application rollback.

> This is a portfolio and laboratory implementation. It demonstrates production-oriented architecture patterns, but it is not presented as a complete enterprise landing zone.

## Project objectives

The platform was created to demonstrate how to:

- Provision Azure infrastructure entirely with Terraform.
- Organize Terraform resources into reusable modules.
- Store Terraform state in a remote backend.
- Authenticate GitHub Actions to Azure through OpenID Connect.
- Avoid long-lived Azure client secrets.
- Build container images through GitHub Actions.
- Tag container images with the Git commit SHA.
- Pull images from ACR using Managed Identity.
- Expose only the frontend to the public internet.
- Protect the backend, Storage Account and Key Vault with Private Endpoints.
- Use Azure RBAC instead of application passwords or access keys.
- Detect infrastructure drift.
- Monitor the application with Azure Monitor.
- Roll back the application to a known healthy version.

## Architecture overview

The solution contains:

- A public frontend Azure Web App.
- A private backend Azure Web App.
- A shared Linux App Service Plan.
- Azure Container Registry.
- A private Azure Storage Account and Blob container.
- Azure Key Vault.
- User-assigned Managed Identities.
- Azure RBAC role assignments.
- Virtual Network integration.
- Private Endpoints.
- Private DNS Zones.
- Application Insights.
- Log Analytics Workspace.
- Azure Monitor diagnostic settings.
- Azure Monitor Action Group.
- GitHub Actions using OIDC.
- Terraform using remote state.

The frontend is the only application component intended to accept public traffic.

The frontend communicates with the backend through Private Link. The backend accesses Blob Storage and Key Vault through Private Endpoints and authenticates using its Managed Identity.

See the complete architecture documentation:

[View the architecture diagram and traffic flows](docs/architecture/architecture.md)

## Application traffic flow

```text
Internet user
    |
    | HTTPS
    v
Public frontend Azure Web App
    |
    | VNet integration and Private DNS
    v
Backend Private Endpoint
    |
    v
Private backend Azure Web App
    |
    +---- Managed Identity ----> Key Vault Private Endpoint
    |
    +---- Managed Identity ----> Blob Storage Private Endpoint
```

A direct public request to the backend is expected to return:

```text
HTTP/1.1 403 Ip Forbidden
```

This is an expected security result.

## Deployment flow

```text
Developer
    |
    v
GitHub Pull Request
    |
    v
Terraform validation and plan
    |
    v
Protected main branch
    |
    v
GitHub Actions using OIDC
    |
    +---- Build frontend image
    |
    +---- Build backend image
    |
    v
Azure Container Registry
    |
    | Images tagged with Git commit SHA
    v
Azure App Service using Managed Identity
```

The deployment does not require an `AZURE_CLIENT_SECRET`.

GitHub requests a short-lived OIDC token, Microsoft Entra ID validates the federated identity, and Azure issues a temporary access token to the workflow.

## Key security controls

| Area | Control |
|---|---|
| GitHub authentication | OpenID Connect federation |
| Azure client secrets | Not used |
| Container registry credentials | ACR administrator account disabled |
| Image downloads | Managed Identity and `AcrPull` |
| Backend network access | Public access disabled |
| Storage network access | Public access disabled |
| Key Vault network access | Public access disabled |
| Private service connectivity | Azure Private Link |
| Name resolution | Azure Private DNS Zones |
| Application authorization | Azure RBAC |
| Storage access keys | Disabled for application access |
| Repository protection | Pull Requests, ruleset and blocked force pushes |
| Secret detection | GitHub Secret Protection and Push Protection |
| Deployment traceability | Images tagged by Git commit SHA |
| Infrastructure drift | Terraform plan with detailed exit codes |

See the full security analysis:

[View security decisions](docs/security/security-decisions.md)

## Azure RBAC assignments

The workloads use separate user-assigned Managed Identities.

| Workload | Azure scope | Role |
|---|---|---|
| Frontend Managed Identity | Azure Container Registry | `AcrPull` |
| Backend Managed Identity | Azure Container Registry | `AcrPull` |
| Backend Managed Identity | Storage Account | `Storage Blob Data Contributor` |
| Backend Managed Identity | Key Vault | `Key Vault Secrets User` |

The application does not use:

- ACR administrator credentials.
- Storage access keys.
- Embedded Key Vault credentials.
- Long-lived Azure client secrets.

## Terraform structure

Terraform is separated into a development environment and reusable modules.

```text
infra/
├── environments/
│   └── dev/
└── modules/
    ├── application/
    ├── identities/
    ├── key-vault/
    ├── monitoring/
    ├── network/
    ├── private-connectivity/
    ├── rbac/
    ├── registry/
    └── storage/
```

The modules manage:

- Networking and subnets.
- Azure Container Registry.
- Storage Account and Blob container.
- Key Vault.
- User-assigned Managed Identities.
- App Service Plan and Web Apps.
- Application Insights and Log Analytics.
- Private Endpoints and Private DNS.
- Azure RBAC assignments.

Terraform moved blocks were used during the refactor to preserve the existing Azure resources and state addresses without recreating the infrastructure.

## GitHub Actions

The repository includes workflows for:

- Terraform validation and planning.
- Azure authentication through OIDC.
- Docker image builds.
- Image publication to ACR.
- Infrastructure and application deployment.

Pull Requests run the Terraform Plan workflow before changes are merged.

The protected `main` branch requires changes to be delivered through Pull Requests.

## Container versioning

Images are tagged with the complete Git commit SHA.

Example:

```text
frontend:71c101f43c996ca4981732c60cea6e220e959813
backend:71c101f43c996ca4981732c60cea6e220e959813
```

This provides:

- A direct relationship between source code and deployment.
- Immutable application versions.
- Repeatable rollback targets.
- Easier incident investigation.
- Reduced dependence on mutable tags such as `latest`.

## Platform validation

The operational validation includes:

| Test | Expected result |
|---|---|
| Frontend health | HTTP 200 |
| Frontend-to-backend connectivity | Both services healthy |
| Key Vault access | Managed Identity authentication |
| Blob Storage access | Existing messages returned |
| Direct public backend request | HTTP 403 |
| Terraform drift check | Exit code 0 |

The detailed commands and troubleshooting procedures are documented in the runbook:

[View the operational runbook](docs/operations/runbook.md)

## Monitoring

The platform includes:

- Application Insights.
- Log Analytics Workspace.
- App Service diagnostic settings.
- Azure Monitor Action Group.
- Application health endpoints.
- Email alerting.
- Terraform drift detection.

The monitoring configuration is intended to provide application, infrastructure and deployment visibility.

## Disaster Recovery

A Disaster Recovery Game Day validated application rollback using previously published container images.

The exercise confirmed:

- A known healthy Git SHA could be used as a rollback target.
- Terraform changed the deployed application versions without recreating the infrastructure.
- Frontend and backend health recovered successfully.
- Private connectivity remained functional.
- Managed Identity access remained functional.
- Pre-existing Blob data remained available.
- The backend remained blocked from public access.
- Terraform reported no remaining drift.

The exact numeric Recovery Time Objective remains pending final timestamp calculation.

[View the Disaster Recovery Game Day report](docs/operations/disaster-recovery-report.md)

## Cost strategy

The environment balances architecture demonstrations with the limits of a personal laboratory subscription.

Cost-control decisions include:

- One shared Basic B1 App Service Plan.
- Basic Azure Container Registry.
- Standard locally redundant Storage.
- Limited Log Analytics retention.
- A daily Log Analytics ingestion quota.
- A target monthly budget of USD 120.
- Removal or shutdown of resources when the environment is not required.

Private Endpoints intentionally increase the cost because private connectivity is one of the primary architectural capabilities demonstrated by the project.

[View the cost analysis](docs/cost/cost-analysis.md)

## Repository documentation

| Document | Purpose |
|---|---|
| [Architecture](docs/architecture/architecture.md) | Architecture diagram, traffic flows and security boundaries |
| [Security decisions](docs/security/security-decisions.md) | Threats, controls, identities, RBAC and trade-offs |
| [Cost analysis](docs/cost/cost-analysis.md) | Cost drivers, budget and optimization opportunities |
| [Operational runbook](docs/operations/runbook.md) | Health validation, troubleshooting and rollback |
| [Disaster Recovery report](docs/operations/disaster-recovery-report.md) | Game Day objectives, execution and results |
| [Evidence checklist](docs/evidence/README.md) | Planned sanitized screenshots |

## Evidence

The portfolio evidence is organized under:

```text
docs/evidence/screenshots/
```

The evidence checklist covers:

1. Architecture diagram.
2. Pull Request with Terraform Plan.
3. GitHub Environment awaiting approval.
4. Successful deployment pipeline.
5. ACR images tagged with commit SHA.
6. Backend public access disabled.
7. Private Endpoints.
8. Private DNS Zones.
9. Managed Identity role assignments.
10. Azure Monitor dashboard.
11. Email alert.
12. Terraform drift detection.
13. Successful rollback.
14. Azure Cost Management.

Screenshots are sanitized before publication.

[View the evidence checklist](docs/evidence/README.md)

## Repository structure

```text
.
├── .github/
│   └── workflows/
├── infra/
│   ├── environments/
│   │   └── dev/
│   └── modules/
├── docs/
│   ├── architecture/
│   ├── cost/
│   ├── evidence/
│   ├── operations/
│   └── security/
└── README.md
```

The repository also contains the application source, Dockerfiles and supporting deployment configuration.

## Known limitations

This project is intentionally scoped as a portfolio laboratory.

Current limitations include:

- Single Azure region.
- No automated regional failover.
- No active-active deployment.
- No Azure Front Door.
- No Web Application Firewall.
- No zone-redundant App Service Plan.
- No production-grade autoscaling.
- No Azure Policy deployment.
- No automated container vulnerability gate.
- No complete enterprise landing-zone implementation.
- No separate development, staging and production subscriptions.
- No automated Terraform state disaster-recovery workflow.
- The Basic App Service tier is not intended for high traffic.
- The exact Disaster Recovery RTO has not yet been calculated from final timestamps.

## Future improvements

Potential improvements include:

- Azure Front Door Premium.
- Web Application Firewall.
- Multi-region deployment.
- Automated regional failover.
- Separate development, staging and production environments.
- Azure Policy assignments.
- Microsoft Defender for Cloud integration.
- Container vulnerability scanning.
- CodeQL or another static-analysis workflow.
- Automated post-deployment health checks.
- Automated rollback workflow.
- Terraform state backup and recovery tests.
- Storage versioning and backup.
- Key Vault purge protection for production.
- ACR image-retention automation.
- Infracost integration in Pull Requests.
- Azure Cost Management exports.
- Automated cleanup of temporary environments.
- Formal RTO and RPO targets.

## Skills demonstrated

This project demonstrates practical experience with:

- Microsoft Azure.
- Terraform.
- Infrastructure as Code.
- GitHub Actions.
- OpenID Connect.
- Microsoft Entra ID.
- Managed Identity.
- Azure RBAC.
- Azure App Service.
- Docker containers.
- Azure Container Registry.
- Azure Virtual Network.
- Private Link.
- Private Endpoints.
- Private DNS.
- Azure Storage.
- Azure Key Vault.
- Application Insights.
- Log Analytics.
- Azure Monitor.
- CI/CD.
- Disaster Recovery.
- Cost optimization.
- Technical documentation.

## Security notice

No secrets, access keys, Terraform state files or private credentials should be committed to this repository.

Public screenshots must not expose:

- Full Azure Subscription IDs.
- Full Microsoft Entra Tenant IDs.
- Personal email addresses.
- Access tokens.
- Client secrets.
- Access keys.
- SAS tokens.
- Terraform state.
- Sensitive Terraform outputs.