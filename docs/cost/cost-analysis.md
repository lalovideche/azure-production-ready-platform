# Cost Analysis

## Objective

The project is designed to demonstrate production-oriented Azure architecture while keeping the environment affordable enough for a personal portfolio and laboratory subscription.

The primary cost goals are:

- Use the smallest practical service tiers.
- Avoid unnecessary duplicate resources.
- Limit monitoring ingestion.
- Maintain private connectivity for security demonstrations.
- Preserve the ability to destroy or scale down the environment when it is not required.

## Main cost drivers

| Azure service | Configuration | Cost consideration |
|---|---|---|
| App Service Plan | Linux Basic B1 | Usually one of the largest recurring costs in the environment |
| Frontend Web App | Runs on the shared App Service Plan | Does not require a separate plan |
| Backend Web App | Runs on the shared App Service Plan | Shares compute cost with the frontend |
| Azure Container Registry | Basic SKU | Lowest practical ACR tier for the project |
| Storage Account | Standard LRS | Low-cost storage for small Blob messages |
| Key Vault | Standard | Consumption depends on operations performed |
| Private Endpoints | Backend, Storage and Key Vault | Each endpoint adds a recurring cost |
| Private DNS Zones | Web Apps, Blob and Key Vault | Small recurring cost plus DNS queries |
| Log Analytics | 30-day retention and daily quota | Ingestion must be controlled to avoid unexpected cost |
| Application Insights | Workspace-based | Cost mainly depends on telemetry ingestion |
| Action Group | Email notification | Normally low usage in this lab |
| Data transfer | Application and registry traffic | Depends on traffic volume and region boundaries |

## Cost-control decisions

### Shared App Service Plan

The frontend and backend use the same App Service Plan.

Benefits:

- Avoids paying for two separate compute plans.
- Demonstrates a multi-application hosting model.
- Keeps the laboratory environment simpler.

Trade-off:

- Both applications share the same compute capacity.
- A resource-intensive workload could affect both applications.

### Basic App Service tier

The project uses a Basic B1 plan because it supports the required App Service features at a lower cost than production-oriented Premium tiers.

Trade-offs:

- No zone redundancy.
- Limited scale and performance.
- Not intended for a high-traffic production workload.

### Basic Azure Container Registry

The Basic ACR tier is sufficient for:

- Storing the frontend image.
- Storing the backend image.
- Maintaining image versions by commit SHA.
- Demonstrating Managed Identity authentication.

A higher tier would only be justified for features such as:

- Larger storage requirements.
- Higher throughput.
- Geo-replication.
- Private Link requirements specific to the registry.

### Standard LRS Storage

Locally redundant storage was selected for the portfolio environment.

Benefits:

- Lower cost.
- Suitable for non-critical laboratory data.

Trade-off:

- Data is replicated inside one Azure region.
- It does not provide regional disaster recovery.

### Monitoring limits

The Log Analytics Workspace uses:

- A 30-day retention period.
- A daily quota of approximately 0.5 GB.

These limits reduce the risk of uncontrolled telemetry ingestion.

Trade-off:

- Older operational evidence may no longer be available.
- High-volume incidents could reach the ingestion cap.

### Private connectivity

Private Endpoints are intentionally included even though they increase cost.

They demonstrate:

- Private backend access.
- Private Storage access.
- Private Key Vault access.
- Private DNS resolution.
- A production-oriented network security model.

For a minimal development environment, removing Private Endpoints would reduce cost, but it would also remove one of the most important architectural demonstrations in the project.

## Budget

The target project budget is:

```text
USD 120 per month