# IaC Violation Samples for Google Security Command Center

This repository contains a collection of sample Infrastructure as Code (IaC) files designed to demonstrate and trigger various IaC violations as defined by Google Security Command Center's [IaC Validation service](https://cloud.google.com/security-command-center/docs/validate-iac).

## Google Disclaimer
This is not an officially supported Google product

## Purpose

The primary goal of this repository is to:

*   **Demonstrate IaC Violations:** Provide concrete examples of common misconfigurations in IaC files (e.g., Terraform) that violate security best practices.
*   **Educate on IaC Security:** Serve as a learning resource for developers and security engineers to understand the types of violations that Google Security Command Center can detect.
*   **Test IaC Scanning:** Allow users to test and validate their IaC scanning setup with Google Security Command Center by using these samples as test cases.
*   **Improve remediation**: Show specific examples of bad IAC that needs to be fixed.

## Prerequisites 
The following are the prerequisites followed when building this repository:

* Google Cloud [Workload Identity with Github Actions](https://cloud.google.com/iam/docs/workload-identity-federation-with-deployment-pipelines#github-actions)
* The following Services need to be enabled to create reports
     - securityposture.googleapis.com
* Workload Identity principal IAM binding for Security Posture report creation.
    - I used:
        - principal://iam.googleapis.com/projects/[PROJECT_ID]/locations/global/workloadIdentityPools/[WORKLOAD_POOL_ID]/subject/repo:dreardon/scc-iac-scanning:ref:refs/heads/main
        - Google Cloud IAM Role, "Security Posture Shift-Left Validator" 
## Local Usage
Code checked into this repository will run a Github Actions IaC evaluation; however, this can be run locally if *securityposture.googleapis.com* and Security Command Center Premium or Enterprise is enabled as documented [here](https://cloud.google.com/security-command-center/docs/validate-iac#gcloud-create-iac). 

`cp terraform.tfvars.example terraform.tfvars`
- Add the correct values to `terraform.tfvars` before running `.iac-eval.sh`

```shell
#!/bin/bash
export _ORGANIZATION_ID=[ORG_ID]

terraform plan -out mainplan.tfplan

terraform show -json mainplan.tfplan > mainplan.json

gcloud scc iac-validation-reports create \
 organizations/$_ORGANIZATION_ID/locations/global \
 --tf-plan-file=mainplan.json \
 --format="json(response.iacValidationReport)" > IaCScanReport.json
```

## Disclaimer

These examples are for educational and testing purposes only. They are intended to demonstrate potential vulnerabilities and should not be used in production environments.

---
