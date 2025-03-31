This directory contains an example for a basic regional private cluster. The module creates the following resources:

- A VPC and a subnet in us-east1.
- The subnet has a primary cidr range for the nodes, and 2 secondary ip ranges for the services and the pods.
- A regional cluster in us-east1.
- Cluster is set to enable private nodes, so all provisioned nodes are assigned only private IPs.
- The control plane public endpoint access is enabled, and accessible from all IPs (0.0.0.0/0) for demo purposes. Restrict this to your own IPs.
- A cloud router and cloud NAT are created to allow the nodes to access the internet.
- A custom service account is created for the nodes, and is assigned to the node pool.
- A single node pool with autoscaling disabled. the node pool has 3 zones, and each zone has 2 nodes.

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
| <a name="module_basic_private_cluster"></a> [basic\_private\_cluster](#module\_basic\_private\_cluster) | git@github.com:jpaulodit/terraform-google-abridge-env.git | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_regional"></a> [cluster\_regional](#input\_cluster\_regional) | Whether the cluster is regional or zonal. If regional, specify the region. | `any` | n/a | yes |
| <a name="input_enable_private_cluster_access_internet"></a> [enable\_private\_cluster\_access\_internet](#input\_enable\_private\_cluster\_access\_internet) | Whether to enable private cluster to have internet access | `any` | n/a | yes |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | List of maps containing node pools configurations | `list(map(any))` | n/a | yes |
| <a name="input_private_master_cidrs"></a> [private\_master\_cidrs](#input\_private\_master\_cidrs) | List of CIDRs from which access to the control plane is allowed. This kicks in when enable\_private\_endpoint is true. If none is provided, only access from the cluster node IPs is allowed. | <pre>list(object({<br/>    cidr_block   = string,<br/>    display_name = string<br/>  }))</pre> | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID. Eg: abridge-hw | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for the cluster. If cluster is regional, specify the region. | `any` | n/a | yes |
| <a name="input_subnet_pods_cidr"></a> [subnet\_pods\_cidr](#input\_subnet\_pods\_cidr) | The pods CIDR block for the subnet. Eg: 10.80.32.0/19 | `any` | n/a | yes |
| <a name="input_subnet_primary_cidr"></a> [subnet\_primary\_cidr](#input\_subnet\_primary\_cidr) | The primary CIDR block for the subnet. Eg: 10.80.0.0/20 | `any` | n/a | yes |
| <a name="input_subnet_services_cidr"></a> [subnet\_services\_cidr](#input\_subnet\_services\_cidr) | The services CIDR block for the subnet. Eg: 10.80.16.0/20 | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
