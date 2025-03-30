This directory contains an example for a zonal private cluster. The module creates the following resources:

- A VPC and a subnet in us-east1.
- The subnet has a primary cidr range for the nodes, and 2 secondary ip ranges for the services and the pods.
- A zonal cluster in us-east1-b.
- Cluster is set to enable private nodes, so all provisioned nodes are assigned only private IPs.
- The control plane public endpoint access is enabled, and accessible from all IPs (0.0.0.0/0) for demo purposes. Restrict this to your own IPs.
- A cloud router and cloud NAT are created to allow the nodes to access the internet.
- A custom service account is created for the nodes.
- A single node pool with autoscaling disabled. The node pool by default has node location us-east1-b.

The variables are assigned inside terraform.tfvars.

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
