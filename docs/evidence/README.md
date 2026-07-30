# Project Evidence

This directory contains sanitized screenshots demonstrating the deployment, security and operational capabilities of the Azure Production-Ready Platform.

## Evidence checklist

| ID | Evidence | Planned file |
|---:|---|---|
| 01 | Architecture diagram | `01-architecture-diagram.png` |
| 02 | Pull Request with Terraform Plan | `02-terraform-plan-pull-request.png` |
| 03 | GitHub Environment awaiting approval | `03-github-environment-approval.png` |
| 04 | Successful deployment pipeline | `04-successful-deployment-pipeline.png` |
| 05 | ACR images tagged with commit SHA | `05-acr-commit-sha-images.png` |
| 06 | Backend public access disabled | `06-backend-public-access-disabled.png` |
| 07 | Private Endpoints | `07-private-endpoints.png` |
| 08 | Private DNS Zones | `08-private-dns-zones.png` |
| 09 | Managed Identity role assignments | `09-managed-identity-rbac.png` |
| 10 | Azure Monitor dashboard | `10-azure-monitor-dashboard.png` |
| 11 | Email alert | `11-monitor-email-alert.png` |
| 12 | Terraform drift detection | `12-terraform-drift-detection.png` |
| 13 | Successful rollback | `13-successful-rollback.png` |
| 14 | Azure Cost Management | `14-cost-management.png` |

## Sanitization requirements

Before committing a screenshot, verify that it does not expose:

- Full Azure Subscription IDs
- Full Microsoft Entra Tenant IDs
- Personal email addresses
- Client secrets
- Access keys
- SAS tokens
- GitHub secrets
- Authentication tokens
- Terraform state
- Sensitive Terraform outputs
- Full managed identity client or principal IDs

Resource names may remain visible when they do not contain personal or confidential information.

## Status

Evidence collection is in progress.