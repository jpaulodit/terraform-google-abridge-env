This directory contains an example for creating multiple extra subnets and service accounts.
For extra subnets use the `additional_subnets` variable.
For extra service accounts, use the `additional_service_accounts` variable. Also, you can attached the service account to the node pool by using the `service_account` field in the `node_pools` variable.
Refer to main.tf file for the full details.

Prerequisite to this example are your own GCP project and Cloud Storage bucket. Update bucket name in main.tf as needed.

To try out this example, run the following commands in this directory

- `terraform init` - to initialize the working directory and download any modules, plugins, etc...
- `terraform plan -out=tfplan` - to see the changes that will be made
- `terraform apply tfplan` - to apply the changes
- `terraform destroy` - to destroy and clean up the work

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gke"></a> [gke](#module\_gke) | git@github.com:jpaulodit/terraform-google-abridge-env.git | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID. Eg: abridge-hw | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for the cluster. If cluster is regional, specify the region. | `string` | `"us-east1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
