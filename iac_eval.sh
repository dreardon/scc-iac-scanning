#!/bin/bash
export _ORGANIZATION_ID=[ORG_ID]

terraform plan -out mainplan.tfplan

terraform show -json mainplan.tfplan > mainplan.json

gcloud scc iac-validation-reports create \
 organizations/$_ORGANIZATION_ID/locations/global \
 --tf-plan-file=mainplan.json \
 --format="json(response.iacValidationReport)" > IaCScanReport.json