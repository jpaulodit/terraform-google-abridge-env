# This module provisions a GCP environment for running a GKE cluster.

At the bare minimum, it creates the following resources
- a VPC
- a subnet
- a service account
- a GKE cluster
- a node pool for the cluster

## Basic Usage

```hcl
module "gke" {
  source = "path/to/module"

  project_id           = "demo-project-id"
  cluster_name         = "demo-cluster"
  region               = "us-central1"
  vpc_name             = "demo-vpc"
  subnet_primary_cidr  = "10.80.0.0/20"
  subnet_services_cidr = "10.80.16.0/20"
  subnet_pods_cidr     = "10.80.32.0/19"
}
```

## Complete Options

```hcl
```

## Examples

There are multiple examples inside the examples directory. The examples are
- basic_public_cluster
- basic_private_cluster
- basic_private_cluster_with_multiple_node_pools


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 6.20.0, < 7 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 6.20.0, < 7 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.iap_ssh](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_network.vpc_network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google_compute_subnetwork.additional_subnets](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_container_cluster.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_project_iam_member.additional_service_account_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.node_sa_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.additional_service_accounts](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.nodes_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [random_id.nodes_sa_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_shuffle.available_zones](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [google_compute_zones.zones](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_main_subnet_cidrs"></a> [additional\_main\_subnet\_cidrs](#input\_additional\_main\_subnet\_cidrs) | Additional secondary ip ranges for the main subnet | <pre>list(object({<br/>    name = string<br/>    cidr = string<br/>  }))</pre> | `[]` | no |
| <a name="input_additional_node_sa_roles"></a> [additional\_node\_sa\_roles](#input\_additional\_node\_sa\_roles) | Additional roles to add to the nodes service account | `list(string)` | `[]` | no |
| <a name="input_additional_service_accounts"></a> [additional\_service\_accounts](#input\_additional\_service\_accounts) | Additional service accounts to create | <pre>list(object({<br/>    name  = string<br/>    roles = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_additional_subnets"></a> [additional\_subnets](#input\_additional\_subnets) | Additional subnets to create | <pre>list(object({<br/>    name = string<br/>    cidr = string<br/>  }))</pre> | `[]` | no |
| <a name="input_autopilot"></a> [autopilot](#input\_autopilot) | Whether to enable autopilot for the cluster | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster | `string` | `"default"` | no |
| <a name="input_cluster_regional"></a> [cluster\_regional](#input\_cluster\_regional) | Cluster is regional if true (recommended), zonal if false | `bool` | `true` | no |
| <a name="input_cluster_resource_labels"></a> [cluster\_resource\_labels](#input\_cluster\_resource\_labels) | Key-value pairs to be added to the cluster | `map(string)` | `{}` | no |
| <a name="input_create_nodes_service_account"></a> [create\_nodes\_service\_account](#input\_create\_nodes\_service\_account) | Whether to create a service account for the nodes in the GKE cluster | `bool` | `true` | no |
| <a name="input_enable_iap_ssh"></a> [enable\_iap\_ssh](#input\_enable\_iap\_ssh) | Whether to enable IAP SSH access to the nodes | `bool` | `false` | no |
| <a name="input_enable_l4_ilb_subsetting"></a> [enable\_l4\_ilb\_subsetting](#input\_enable\_l4\_ilb\_subsetting) | Whether to enable L4 ILB subsetting | `bool` | `true` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | List of maps containing node pools configurations | `list(map(any))` | <pre>[<br/>  {<br/>    "name": "default-node-pool"<br/>  }<br/>]</pre> | no |
| <a name="input_private_ip_google_access"></a> [private\_ip\_google\_access](#input\_private\_ip\_google\_access) | Whether to enable private IP Google access for the subnet | `bool` | `true` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for the cluster. If cluster is regional, specify the region. | `string` | `"us-east1"` | no |
| <a name="input_subnet_pods_cidr"></a> [subnet\_pods\_cidr](#input\_subnet\_pods\_cidr) | The pods CIDR block for the subnet. Eg: 10.80.32.0/19 | `string` | n/a | yes |
| <a name="input_subnet_primary_cidr"></a> [subnet\_primary\_cidr](#input\_subnet\_primary\_cidr) | The primary CIDR block for the subnet. Eg: 10.80.0.0/20 | `string` | n/a | yes |
| <a name="input_subnet_services_cidr"></a> [subnet\_services\_cidr](#input\_subnet\_services\_cidr) | The services CIDR block for the subnet. Eg: 10.80.16.0/20 | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC | `string` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | The zones to host the cluster in. If you want a zonal cluster, specify a single zone. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the cluster |
| <a name="output_node_locations"></a> [node\_locations](#output\_node\_locations) | The locations of the nodes |
| <a name="output_node_service_account_email"></a> [node\_service\_account\_email](#output\_node\_service\_account\_email) | The email address of the service account |
<!-- END_TF_DOCS -->
