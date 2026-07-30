# Operational Runbook

## Purpose

This runbook explains how to validate, operate, troubleshoot and recover the Azure Production-Ready Platform.

The commands in this document are not intended to be executed from beginning to end. Each section explains when its commands should be used.

The runbook covers:

- Routine application health validation.
- Terraform configuration validation.
- Infrastructure drift detection.
- Standard deployment procedures.
- Application rollback.
- Private connectivity troubleshooting.
- Managed Identity and Azure RBAC troubleshooting.
- Monitoring and incident evidence collection.

## Platform components

The platform includes:

- Public frontend Azure Web App.
- Private backend Azure Web App.
- Shared Linux App Service Plan.
- Azure Container Registry.
- Storage Account with a private Blob container.
- Azure Key Vault.
- User-assigned managed identities.
- Azure RBAC assignments.
- Virtual Network integration.
- Private Endpoints.
- Private DNS Zones.
- Application Insights.
- Log Analytics Workspace.
- Azure Monitor diagnostic settings.
- Azure Monitor Action Group.
- GitHub Actions using OpenID Connect.
- Terraform using remote state.

## Prerequisites

Before operating the platform, verify that:

- Azure CLI is installed.
- Azure CLI is authenticated.
- Terraform is installed.
- Git is installed.
- PowerShell is available.
- The repository is synchronized with GitHub.
- The correct Azure subscription is selected.
- The Terraform image-tag variables contain valid image tags.
- Terraform state and secret files are not stored in the repository.

To review the currently selected Azure subscription:

```powershell
az account show `
  --query "{Subscription:name, Tenant:tenantId}" `
  --output table
```

> [!CAUTION]
> Do not include complete Subscription IDs, Tenant IDs or personal email addresses in public screenshots.

---

## Routine platform validation

### When to use this section

Run these tests when:

- A deployment has completed.
- You want to confirm that the platform is healthy.
- You are collecting portfolio evidence.
- You are investigating an application problem.
- A rollback has completed.

### Open the Terraform environment

Open PowerShell from the root directory of the cloned repository.

Navigate to the Terraform environment:

```powershell
Set-Location .\infra\environments\dev
```

Confirm the current directory:

```powershell
Get-Location
```

The path should end with:

```text
infra\environments\dev
```

### Load the application hostnames

Run:

```powershell
$FRONTEND_HOSTNAME = terraform output -raw frontend_hostname
$BACKEND_HOSTNAME  = terraform output -raw backend_hostname

Write-Host "Frontend hostname: $FRONTEND_HOSTNAME"
Write-Host "Backend hostname:  $BACKEND_HOSTNAME"
```

Expected format:

```text
Frontend hostname: app-azrp-front-dev-<suffix>.azurewebsites.net
Backend hostname:  app-azrp-back-dev-<suffix>.azurewebsites.net
```

Both variables must contain valid hostnames before continuing.

If either variable is empty, verify that PowerShell is currently located in:

```text
infra\environments\dev
```

### Test 1: frontend health

Run:

```powershell
curl.exe `
  --silent `
  --show-error `
  --include `
  --max-time 60 `
  "https://$FRONTEND_HOSTNAME/health"
```

Expected status:

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

This test confirms that:

- The frontend App Service is running.
- The frontend container started successfully.
- The frontend image was downloaded from ACR.
- The frontend health endpoint is responding.

### Test 2: frontend-to-backend private connectivity

Run:

```powershell
curl.exe `
  --silent `
  --show-error `
  --include `
  --max-time 60 `
  "https://$FRONTEND_HOSTNAME/health/dependencies"
```

Expected status:

```text
HTTP/1.1 200 OK
```

Expected response structure:

```json
{
  "backend": {
    "service": "backend",
    "status": "healthy"
  },
  "frontend": "healthy",
  "status": "healthy"
}
```

This test confirms that:

- The frontend is healthy.
- The frontend is integrated with the Virtual Network.
- Private DNS resolves the backend hostname.
- Traffic reaches the backend through Private Link.
- The backend application is healthy.

### Test 3: Managed Identity and Key Vault

Run:

```powershell
curl.exe `
  --silent `
  --show-error `
  --include `
  --max-time 60 `
  "https://$FRONTEND_HOSTNAME/api/info"
```

Expected status:

```text
HTTP/1.1 200 OK
```

The response should include information similar to:

```json
{
  "authentication": "Managed Identity",
  "service": "backend"
}
```

This test confirms that:

- The frontend can communicate with the backend.
- The backend Managed Identity is working.
- The backend has the required Key Vault RBAC role.
- The Key Vault Private Endpoint is working.
- Private DNS resolves the Key Vault private address.

> [!CAUTION]
> Do not publish a real secret value in screenshots or documentation.

### Test 4: Managed Identity and Blob Storage

Run:

```powershell
curl.exe `
  --silent `
  --show-error `
  --include `
  --max-time 60 `
  "https://$FRONTEND_HOSTNAME/api/messages"
```

Expected status:

```text
HTTP/1.1 200 OK
```

The response should include the messages stored in the private Blob container.

This test confirms that:

- The backend Managed Identity is working.
- The backend has the required Storage RBAC role.
- The Blob Private Endpoint is working.
- Private DNS resolves the Blob Storage private address.
- The private Blob container is accessible.

### Test 5: backend public access is blocked

Run:

```powershell
curl.exe `
  --silent `
  --show-error `
  --include `
  --max-time 30 `
  "https://$BACKEND_HOSTNAME/health"
```

Expected status:

```text
HTTP/1.1 403 Ip Forbidden
```

This is an expected security result.

The backend must not be directly accessible from the public internet.

A public `HTTP 200` response from the backend would represent a security failure.

---

## Terraform validation

### When to use this section

Run these commands when:

- Terraform files have been modified.
- A Pull Request is being prepared.
- You are investigating Terraform errors.
- You want to confirm that the configuration is valid.

Do not run `terraform apply` simply because it appears in another section of this runbook.

All Terraform commands in this section must be executed from:

```text
infra\environments\dev
```

### Initialize Terraform

Run:

```powershell
terraform init
```

This initializes:

- The configured remote backend.
- Terraform providers.
- Local Terraform modules.

Do not use `terraform init -reconfigure` unless the backend configuration intentionally changed.

### Validate the configuration

Run:

```powershell
terraform validate
```

Expected result:

```text
Success! The configuration is valid.
```

If validation fails, correct the error before generating or applying a Terraform plan.

### Verify the application image tags

Run:

```powershell
Write-Host "Frontend tag: $env:TF_VAR_frontend_image_tag"
Write-Host "Backend tag:  $env:TF_VAR_backend_image_tag"
```

Expected format:

```text
Frontend tag: <git-commit-sha>
Backend tag:  <git-commit-sha>
```

Do not continue with a Terraform plan if the variables are unexpectedly empty.

---

## Terraform drift detection

### When to use this section

Run drift detection when:

- Someone may have changed Azure manually.
- You want to compare Azure with the Terraform code.
- You are performing an audit.
- A deployment produced an unexpected result.
- You are collecting drift-detection evidence.

### Run the drift check

Execute:

```powershell
terraform plan `
  -input=false `
  -detailed-exitcode

$TERRAFORM_EXIT_CODE = $LASTEXITCODE

Write-Host "Terraform exit code: $TERRAFORM_EXIT_CODE"
```

Interpret the result as follows:

| Exit code | Meaning |
|---:|---|
| `0` | No drift or pending changes |
| `1` | Terraform encountered an error |
| `2` | Terraform detected changes |

Expected healthy result:

```text
No changes. Your infrastructure matches the configuration.
Terraform exit code: 0
```

> [!WARNING]
> Exit code `2` does not mean that the changes should be applied automatically.

Before applying any change, determine whether it represents:

- An intentional Terraform code change.
- A manual Azure Portal modification.
- A missing Terraform variable.
- An incorrect application image tag.
- Provider normalization.
- A changed provider version.
- A missing moved block.
- Actual infrastructure drift.

Do not apply unexpected changes until their cause is understood.

---

## Standard deployment procedure

### Purpose of this section

This section describes the normal GitHub deployment process.

It is a reference procedure. It is not necessary to create a deployment while reading this document.

### Deployment workflow

1. Synchronize the local `main` branch.
2. Create a feature branch.
3. Make the required changes.
4. Validate the changes locally.
5. Commit the changes.
6. Push the feature branch.
7. Create a Pull Request.
8. Review the required Terraform Plan check.
9. Resolve all Pull Request conversations.
10. Merge only when all required checks pass.
11. Monitor the deployment workflow.
12. Execute the health checks in this runbook.

Do not push directly to `main`.

### Create a feature branch

From the repository root:

```powershell
git switch main
git pull origin main
git switch -c <branch-name>
```

Replace `<branch-name>` with a descriptive name such as:

```text
feature/add-monitoring
fix/backend-connectivity
docs/update-runbook
```

### Validate Git changes

Before committing:

```powershell
git diff --check
git status --short
```

Before merging the Pull Request, confirm that the following check completed successfully:

```text
Validate and plan Terraform
```

---

## Container image validation

### When to use this section

Use this section when:

- Verifying a deployment.
- Investigating an App Service startup failure.
- Preparing an application rollback.
- Confirming which source-code version is deployed.

The frontend and backend images must be tagged with a Git commit SHA.

Expected format:

```text
frontend:<git-commit-sha>
backend:<git-commit-sha>
```

This provides:

- Traceability between source code and deployments.
- Predictable rollback targets.
- Clear identification of deployed versions.
- Reduced dependency on mutable tags such as `latest`.

Before rollback, confirm that the target commit SHA exists in Azure Container Registry for both applications.

Do not select a rollback SHA that is unavailable in ACR.

---

## Application rollback

### When to use this section

Use this procedure only when:

- A newly deployed image fails health checks.
- The frontend cannot reach the backend after deployment.
- The backend cannot access Key Vault or Storage.
- A deployment introduces a functional regression.
- Restoring a previous image is safer than correcting the issue immediately.
- An approved Disaster Recovery exercise is being performed.

> [!WARNING]
> Do not execute the rollback commands during routine documentation work.
>
> A rollback changes the application versions deployed in Azure.
>
> Always review the Terraform plan before applying it.

### Identify the last healthy version

Review recent Git commits:

```powershell
git log --oneline -10
```

Identify the last known healthy commit SHA.

Confirm that the corresponding frontend and backend image tags exist in ACR.

### Configure the rollback image tags

Replace the placeholder with the previous healthy commit SHA:

```powershell
$env:TF_VAR_frontend_image_tag = "<previous-healthy-commit-sha>"
$env:TF_VAR_backend_image_tag  = "<previous-healthy-commit-sha>"
```

Verify the values:

```powershell
Write-Host "Rollback frontend tag: $env:TF_VAR_frontend_image_tag"
Write-Host "Rollback backend tag:  $env:TF_VAR_backend_image_tag"
```

### Generate the rollback plan

Run:

```powershell
terraform validate

terraform plan `
  -input=false `
  -out="rollback.tfplan"
```

Review the plan carefully.

The rollback plan should only change the expected application image versions.

Do not apply the plan if Terraform proposes unexpected changes to:

- Networking.
- Private Endpoints.
- Private DNS Zones.
- Storage.
- Key Vault.
- Managed identities.
- Role assignments.
- Monitoring.
- Resource Group.
- Terraform state configuration.

### Apply the approved rollback

Only after reviewing and approving the plan:

```powershell
terraform apply "rollback.tfplan"
```

Remove the saved plan after completion:

```powershell
Remove-Item .\rollback.tfplan -ErrorAction SilentlyContinue
```

### Validate the rollback

After the rollback, repeat:

1. Frontend health.
2. Frontend-to-backend private connectivity.
3. Key Vault access.
4. Blob Storage access.
5. Backend public access blocked.
6. Terraform drift detection.
7. Verification that pre-existing Blob messages remain available.

---

## Troubleshooting scenarios

The following sections are troubleshooting checklists.

Use only the checklist related to the current failure.

### Frontend is unavailable

Check:

1. Frontend App Service status.
2. Frontend container logs.
3. Frontend image tag.
4. Image availability in ACR.
5. Frontend Managed Identity assignment.
6. Frontend `AcrPull` RBAC assignment.
7. App Service application settings.
8. Application Insights failures.
9. App Service startup logs.
10. App Service Plan status.

### Frontend cannot reach the backend

Check:

1. Backend App Service health.
2. Frontend VNet integration.
3. Backend Private Endpoint status.
4. Web Apps Private DNS Zone.
5. Private DNS Zone Virtual Network link.
6. Backend hostname resolution.
7. Network Security Group configuration.
8. Frontend `BACKEND_URL` application setting.
9. Backend container startup status.

The backend public network access should remain disabled while troubleshooting.

Do not permanently enable public backend access as a workaround.

### Backend cannot access Key Vault

Check:

1. Backend Managed Identity assignment.
2. Backend Managed Identity client ID.
3. `Key Vault Secrets User` RBAC assignment.
4. Key Vault Private Endpoint.
5. Key Vault Private DNS Zone.
6. Private DNS Zone Virtual Network link.
7. Key Vault public network configuration.
8. Key Vault URL application setting.
9. Key Vault RBAC authorization configuration.
10. Key Vault secret availability.

### Backend cannot access Blob Storage

Check:

1. Backend Managed Identity assignment.
2. `Storage Blob Data Contributor` RBAC assignment.
3. Blob Private Endpoint.
4. Blob Private DNS Zone.
5. Private DNS Zone Virtual Network link.
6. Storage public network configuration.
7. Blob container name.
8. Storage Account name application setting.
9. Storage Account OAuth configuration.
10. Blob container availability.

### App Service cannot pull an image from ACR

Check:

1. The image tag exists in ACR.
2. The correct image repository is configured.
3. Managed Identity is assigned to the Web App.
4. The `AcrPull` role assignment exists.
5. The correct Managed Identity client ID is configured.
6. The ACR login server is correct.
7. ACR administrator credentials remain disabled.
8. App Service container logs.
9. The image architecture is supported.
10. The application port is configured correctly.

### GitHub Actions cannot authenticate to Azure

Check:

1. The workflow has `id-token: write`.
2. The Azure login action uses OIDC.
3. The Azure client ID is correct.
4. The tenant value is correct.
5. The subscription value is correct.
6. The federated credential matches the GitHub repository.
7. The federated credential matches the branch, environment or Pull Request context.
8. The GitHub Environment name is correct.
9. No Azure client secret is expected or required.

### Terraform reports unexpected changes

Check:

1. Image-tag environment variables.
2. Current Git branch.
3. Local uncommitted changes.
4. Azure Portal manual modifications.
5. Provider version changes.
6. Missing or changed Terraform variables.
7. Terraform state synchronization.
8. Resources moved into modules.
9. Current remote backend configuration.
10. Recently changed lifecycle blocks.

Do not apply unexpected changes until their origin is understood.

---

## Monitoring and logs

Use the following tools during troubleshooting:

- Application Insights.
- Log Analytics Workspace.
- Azure Monitor.
- App Service Log Stream.
- App Service container logs.
- Azure Activity Log.
- GitHub Actions workflow logs.
- Terraform plan output.

Recommended investigation order:

1. Confirm the user-visible symptom.
2. Record the failure timestamp.
3. Review application health endpoints.
4. Review recent deployments.
5. Review App Service container logs.
6. Review Application Insights failures.
7. Review Azure Activity Log.
8. Run a Terraform drift check.
9. Compare the deployed image SHA with Git history.
10. Confirm Managed Identity and Private Endpoint status.

---

## Evidence collection

### When to use this section

Follow these rules whenever screenshots are being collected for GitHub, LinkedIn or project documentation.

Store sanitized screenshots under:

```text
docs/evidence/screenshots/
```

Before saving a screenshot, verify that it does not expose:

- Complete Azure Subscription IDs.
- Complete Microsoft Entra Tenant IDs.
- Personal email addresses.
- Client secrets.
- Access keys.
- SAS tokens.
- Authentication tokens.
- GitHub secrets.
- Terraform state.
- Sensitive Terraform outputs.
- Complete Managed Identity client IDs.
- Complete Managed Identity principal IDs.
- Billing information.

Resource names may remain visible when they do not contain confidential or personal information.

---

## Incident record

For each meaningful incident or Disaster Recovery exercise, record:

| Field | Description |
|---|---|
| Start time | Time the incident or exercise began |
| Detection source | Alert, health check, user report or manual test |
| Affected component | Frontend, backend, network, identity, Storage or Key Vault |
| User impact | Functionality that was unavailable |
| Previous healthy SHA | Last known healthy deployment |
| Current SHA | Version associated with the incident |
| Terraform result | Plan exit code and relevant result |
| Recovery action | Rollback, configuration correction or redeployment |
| Recovery completion time | Time service was restored |
| Data loss assessment | Whether persistent data was lost |
| Follow-up actions | Corrective or preventive improvements |

---

## Escalation checklist

Before escalating an issue, collect:

- Exact failure timestamp.
- HTTP status code.
- Affected endpoint.
- Recent deployment SHA.
- Last known healthy SHA.
- Relevant GitHub Actions run.
- Terraform validation result.
- Terraform plan result.
- App Service container logs.
- Application Insights failure details.
- Private Endpoint connection status.
- Managed Identity assignment status.
- Azure RBAC assignment status.
- User or business impact.

Never include credentials, secrets or complete Azure identifiers in an escalation document that will be published publicly.