# GCP AlloyDB PostgreSQL Terraform Automation

Production-oriented baseline for AlloyDB with a regional HA primary, read pool, continuous backup/PITR, automated backups, CMEK, private service access, audit logging, Cloud Monitoring, a cross-region secondary cluster, and GitHub Actions.

## Important design decisions
- No database password is stored in Terraform. Bootstrap database roles separately through an approved secrets workflow.
- Production uses AlloyDB deletion protection. To intentionally remove protected clusters, follow a controlled break-glass change that first disables deletion protection in the environment variables.
- DR promotion/switchover is an operational action. After promotion, update cluster roles in code and run the supplied refresh-only reconciliation workflow.
- The included alert is a baseline. Add organization-approved metrics and thresholds after validating metric descriptors in the target project.

## Prerequisites
1. A GCP project and billing.
2. A pre-created, versioned GCS state bucket.
3. GitHub OIDC/Workload Identity Federation connected to a least-privilege Terraform service account.
4. GitHub Environments named `dev`, `qa`, `prod`, `qa-dr`, and `prod-dr`; configure required reviewers for manual approvals.
5. Secrets in each GitHub Environment: `GCP_WIF_PROVIDER`, `GCP_TERRAFORM_SERVICE_ACCOUNT`, and `TF_STATE_BUCKET`.

## Local use
```bash
terraform fmt -recursive
terraform init -backend-config="bucket=YOUR_STATE_BUCKET" -backend-config="prefix=alloydb/dev"
terraform validate
terraform plan -var-file=environments/dev.tfvars
```

## Read pool autoscaling
The Google Terraform provider exposes a fixed AlloyDB read-pool node count, so
runtime scaling is handled by `scripts/read-pool-autoscaler.sh`. Terraform
ignores only the read-pool node count so it does not revert runtime scaling.

Run it from a scheduler or monitoring-triggered job with Google Cloud CLI and
`jq` installed:
```bash
scripts/read-pool-autoscaler.sh \
	--project project-dba-48524 \
	--region asia-south1 \
	--cluster alloydb-primary-dev \
	--instance alloydb-read-pool-dev \
	--min-nodes 1 \
	--max-nodes 3
```
Use `--dry-run` to inspect the decision without changing AlloyDB. The service
account needs Monitoring Viewer and AlloyDB Instance Admin permissions.

## Deployment order
1. Replace placeholders in the environment tfvars.
2. Run PR validation.
3. Run workflow action `plan`.
4. Run `apply`; GitHub Environment protection provides the approval gate.
5. Validate private connectivity, dashboards, backups, and application smoke tests.
6. For production DR, execute and document a controlled switchover test, then reconcile Terraform state.

## Notes
- The VPC module creates a dedicated VPC and Private Service Access range. For Shared VPC, replace it with data sources for the host-project network and grant the required service-agent permissions.
- Adjust CPU counts, retention, regions, labels, flags, alert thresholds, and IAM to organizational standards before production use.
- Do not run destroy against production unless the approved break-glass changes have removed protection.
