#!/bin/bash
export _ORGANIZATION_ID=[ORG_ID]
export TF_VAR_PROJECT_ID=[PROJECT_ID]
export TF_VAR_BQ_OWNER=[EMAIL e.g. test@test.com]
export TF_VAR_ZONE=[ZONE e.g. us-central1-a]
export TF_VAR_REGION=[REGION e.g. us-central1] 

terraform plan -out mainplan.tfplan

terraform show -json mainplan.tfplan > mainplan.json

gcloud scc iac-validation-reports create \
 organizations/$_ORGANIZATION_ID/locations/global \
 --tf-plan-file=mainplan.json \
 --format="json(response.iacValidationReport)" > IaCScanReport.json