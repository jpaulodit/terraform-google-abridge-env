# single_zonal_cluster

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
| <a name="module_single_zonal_cluster"></a> [single\_zonal\_cluster](#module\_single\_zonal\_cluster) | git@github.com:jpaulodit/terraform-google-abridge-env.git | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID. Eg: learn-gke-454605-f0 | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for the cluster. If cluster is regional, specify the region. | `string` | `"us-east1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
