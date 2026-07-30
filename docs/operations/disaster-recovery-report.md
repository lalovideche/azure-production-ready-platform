# Disaster Recovery Game Day Report

## Executive summary

This report documents a Disaster Recovery Game Day performed for the Azure Production-Ready Platform.

The exercise validated that the containerized application could be returned to a known healthy version while preserving the persistent data stored in Azure Blob Storage.

The recovery process used:

- Container images tagged with Git commit SHAs.
- Terraform-managed application image versions.
- Azure Container Registry.
- Azure App Service.
- Managed Identity.
- Private Endpoints.
- Private DNS Zones.
- Azure Blob Storage.
- Azure Key Vault.

Overall result:

```text
DISASTER RECOVERY GAME DAY: PASSED
```

## Exercise information

| Field | Value |
|---|---|
| Project | Azure Production-Ready Platform |
| Environment | Development |
| Exercise type | Application rollback and data-persistence validation |
| Exercise date | July 29, 2026 |
| Application platform | Azure App Service |
| Infrastructure management | Terraform |
| Deployment platform | GitHub Actions |
| Container registry | Azure Container Registry |
| Persistent data service | Azure Blob Storage |

## Objectives

The exercise was designed to validate the following capabilities:

1. Identify a known healthy application version.
2. Confirm that the corresponding container images existed in ACR.
3. Roll back the frontend and backend using immutable Git SHA image tags.
4. Preserve the existing Azure infrastructure during recovery.
5. Restore application health.
6. Preserve pre-existing Blob Storage data.
7. Maintain private connectivity after rollback.
8. Maintain Managed Identity authentication after rollback.
9. Confirm that the backend remained inaccessible from the public internet.
10. Confirm that Terraform detected no remaining configuration drift.

## Architecture under test

The recovery scenario included:

- A publicly accessible frontend Azure Web App.
- A backend Azure Web App with public access disabled.
- A shared Linux App Service Plan.
- Azure Container Registry images tagged with Git commit SHAs.
- A backend Private Endpoint.
- A Blob Storage Private Endpoint.
- A Key Vault Private Endpoint.
- Private DNS Zones for Web Apps, Blob Storage and Key Vault.
- User-assigned Managed Identities.
- Azure RBAC assignments.
- Application Insights and Log Analytics.
- Terraform remote state.

## Recovery strategy

The recovery strategy focused on application rollback rather than rebuilding the full infrastructure.

Terraform manages the image tags used by the frontend and backend App Services.

A previous healthy Git commit SHA can therefore be used as a repeatable rollback target:

```text
frontend:<previous-healthy-commit-sha>
backend:<previous-healthy-commit-sha>
```

This approach allows the application version to be changed without recreating:

- The Virtual Network.
- Private Endpoints.
- Private DNS Zones.
- Storage.
- Key Vault.
- Managed Identities.
- Role assignments.
- Monitoring resources.

## Success criteria

The exercise was considered successful when all of the following conditions were met:

- The frontend health endpoint returned HTTP 200.
- The frontend reached the backend through private connectivity.
- The backend successfully accessed Key Vault using Managed Identity.
- The backend successfully accessed Blob Storage using Managed Identity.
- A Blob message created before recovery remained available.
- The backend remained blocked from direct public access.
- Terraform reported no pending infrastructure changes.
- No infrastructure resources were recreated during rollback.

## Recovery Point Objective validation

### Objective

The tested Recovery Point Objective was:

```text
No loss of pre-existing Blob messages.
```

### Validation method

Before recovery, a uniquely identifiable baseline message was stored in the private Blob container.

After rollback, the application queried Blob Storage and returned the message successfully.

### Result

```text
RPO validation: PASSED
```

Within the scope of this exercise, the application rollback caused no loss of the pre-existing Blob message.

This result validates application-level rollback persistence. It does not prove zero data loss for every possible Azure Storage or regional disaster scenario.

## Recovery Time Objective validation

### Objective

The Recovery Time Objective measures how long it takes to restore the application after the recovery process begins.

The calculation should use:

```text
Recovery completion timestamp - recovery start timestamp
```

### Result

```text
Recoverability validation: PASSED
Exact measured RTO: pending final timestamp calculation
```

The application was successfully restored to a healthy version.

A numeric RTO should not be published until the original start and completion timestamps have been confirmed from the exercise records or deployment logs.

## Exercise procedure

### Step 1: establish the healthy baseline

Before introducing or recovering from a failure, the following tests were completed:

- Frontend health.
- Frontend-to-backend dependency health.
- Key Vault access.
- Blob Storage access.
- Backend public-access restriction.
- Terraform configuration validation.

### Step 2: create persistent baseline data

A unique message was written to the private Blob container.

The message was intended to confirm whether application rollback affected persistent data.

Example format:

```text
DR Game Day baseline <timestamp>
```

The exact message value does not need to be published in screenshots.

### Step 3: identify the recovery version

A previously healthy Git commit SHA was identified.

The corresponding frontend and backend container image tags were confirmed in Azure Container Registry.

The target image tags followed this structure:

```text
frontend:<healthy-commit-sha>
backend:<healthy-commit-sha>
```

### Step 4: configure the rollback

The Terraform image-tag variables were configured to reference the previous healthy commit SHA.

Example procedure:

```powershell
$env:TF_VAR_frontend_image_tag = "<previous-healthy-commit-sha>"
$env:TF_VAR_backend_image_tag  = "<previous-healthy-commit-sha>"
```

### Step 5: generate the rollback plan

Terraform validation and planning were performed before applying the rollback.

Example:

```powershell
terraform validate

terraform plan `
  -input=false `
  -out="rollback.tfplan"
```

The plan was reviewed to confirm that it changed only the expected application image versions.

It did not propose recreating the surrounding infrastructure.

### Step 6: apply the rollback

After reviewing the plan, the rollback was applied:

```powershell
terraform apply "rollback.tfplan"
```

The temporary plan file was removed after use.

### Step 7: validate application recovery

The application was tested after rollback.

Results:

| Validation | Result |
|---|---|
| Frontend health | Passed |
| Frontend-to-backend private connectivity | Passed |
| Key Vault access through Managed Identity | Passed |
| Blob Storage access through Managed Identity | Passed |
| Backend public access blocked | Passed |
| Pre-existing Blob message available | Passed |
| Terraform no-drift check | Passed |

## Post-recovery health validation

### Frontend health

Expected result:

```text
HTTP/1.1 200 OK
```

Expected response:

```json
{
  "service": "frontend",
  "status": "healthy"
}
```

Result:

```text
PASSED
```

### Frontend-to-backend connectivity

The frontend dependency endpoint confirmed that both the frontend and backend were healthy.

Expected result:

```text
HTTP/1.1 200 OK
```

Result:

```text
PASSED
```

This also confirmed that the following components continued to work:

- Frontend VNet integration.
- Private DNS resolution.
- Backend Private Endpoint.
- Backend App Service.

### Key Vault access

The application confirmed that the backend continued using Managed Identity.

Result:

```text
PASSED
```

This validated:

- Backend Managed Identity.
- Key Vault RBAC authorization.
- Key Vault Private Endpoint.
- Key Vault Private DNS resolution.

### Blob Storage access

The application successfully retrieved messages from the private Blob container.

Result:

```text
PASSED
```

This validated:

- Backend Managed Identity.
- Storage Blob Data Contributor role.
- Blob Private Endpoint.
- Blob Private DNS resolution.
- Persistent application data.

### Backend public-access restriction

A direct public request to the backend returned:

```text
HTTP/1.1 403 Ip Forbidden
```

Result:

```text
PASSED
```

The backend remained protected from direct public access after rollback.

## Data-persistence result

The unique Blob message created before the recovery process remained available afterward.

Result:

```text
No pre-existing Blob message was lost.
```

The rollback changed the application container versions without deleting or recreating the Storage Account or Blob container.

## Terraform state validation

After recovery, Terraform was used to compare the deployed Azure resources with the configuration.

Expected result:

```text
No changes. Your infrastructure matches the configuration.
```

Expected detailed exit code:

```text
0
```

Result:

```text
Terraform drift validation: PASSED
```

This confirmed that the application recovery left the Terraform-managed environment synchronized.

## Exercise outcome

The Game Day demonstrated that:

- Git SHA image tags provide identifiable rollback targets.
- Terraform can control application image rollback safely.
- App Service versions can be changed without rebuilding the infrastructure.
- Private connectivity remains functional after rollback.
- Managed Identity access remains functional after rollback.
- Existing Blob data survives application rollback.
- The backend remains inaccessible from the public internet.
- Terraform can verify that no configuration drift remains after recovery.

Overall result:

```text
DISASTER RECOVERY GAME DAY: PASSED
```

## Security controls maintained during recovery

The rollback did not require weakening the security configuration.

The following controls remained enabled:

- Backend public network access disabled.
- Storage public network access disabled.
- Key Vault public network access disabled.
- Managed Identity authentication.
- Azure RBAC authorization.
- Private Endpoints.
- Private DNS Zones.
- ACR administrator credentials disabled.
- GitHub OIDC authentication.
- Terraform remote state.

## Evidence requirements

The final portfolio should include sanitized evidence of:

1. ACR images tagged by Git commit SHA.
2. The reviewed Terraform rollback plan.
3. The successful rollback execution.
4. Frontend health after recovery.
5. Frontend-to-backend dependency health.
6. Managed Identity access to Key Vault.
7. Managed Identity access to Blob Storage.
8. The baseline Blob message after recovery.
9. The backend public-access restriction.
10. The final Terraform no-drift result.

Planned screenshot:

```text
docs/evidence/screenshots/13-successful-rollback.png
```

Before publishing evidence, hide:

- Full Azure Subscription IDs.
- Full Microsoft Entra Tenant IDs.
- Personal email addresses.
- Access tokens.
- Access keys.
- Client secrets.
- Terraform state.
- Full Managed Identity client or principal IDs.

## Limitations of the exercise

This exercise validated application rollback, but it did not test:

- Complete Azure region failure.
- Storage Account regional disaster.
- Key Vault regional disaster.
- Loss or corruption of the Terraform state backend.
- Accidental deletion of the Resource Group.
- Loss of the GitHub repository.
- Compromise of GitHub credentials.
- Compromise of an Azure administrative identity.
- Restoration of deleted Blob data.
- Restoration of deleted Key Vault secrets.
- Active-active application failover.
- Automated DNS failover.
- Multi-region deployment.

The current platform is deployed in a single Azure region and does not provide automated regional failover.

## Recommended future Game Days

Future exercises should test:

1. Complete infrastructure recreation from Terraform.
2. Terraform state backup and recovery.
3. Storage soft-delete restoration.
4. Blob version restoration.
5. Key Vault secret recovery.
6. ACR image deletion and restoration.
7. Managed Identity role assignment removal.
8. Private DNS misconfiguration.
9. Private Endpoint failure.
10. GitHub OIDC misconfiguration.
11. Resource Group deletion.
12. Multi-region deployment and failover.

## Improvement actions

Recommended improvements include:

- Automatically record recovery start and completion timestamps.
- Establish a formal numeric RTO target.
- Establish a formal RPO target for each data service.
- Enable and test Storage data-protection features.
- Enable Key Vault purge protection for production environments.
- Maintain a documented list of known healthy image SHAs.
- Add a controlled GitHub Actions rollback workflow.
- Add automated post-deployment health tests.
- Add automatic rollback conditions where appropriate.
- Test recovery of the Terraform state backend.
- Implement multi-region architecture for stronger resilience.