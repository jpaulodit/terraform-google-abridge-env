# This module provisions a GCP environment for running a GKE cluster.

## Features


At the bare minimum, it creates the following resources
- a VPC
- a subnet
- a service account
- a regional GKE cluster
- a public node pool with autoscale enabled for the cluster

## Basic Usage

```hcl
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = "<PROJECT_ID>" # set this to your own project ID.
  region  = "us-east1"
}

module "gke" {
  source = "git@github.com:jpaulodit/terraform-google-abridge-env.git"

  project_id           = "<PROJECT_ID>"
  cluster_name         = "demo-cluster"
  region               = "us-east1"
  vpc_name             = "demo-vpc"
  subnet_primary_cidr  = "10.80.0.0/20"
  subnet_services_cidr = "10.80.16.0/20"
  subnet_pods_cidr     = "10.80.32.0/19"
}
```

## Complete Options

```hcl
module "gke" {
  source = "git@github.com:jpaulodit/terraform-google-abridge-env.git"
  
  project_id           = "<PROJECT_ID>"
  region               = "us-east1"
  cluster_regional     = true
  vpc_name             = "demo-vpc"
  subnet_primary_cidr  = "10.80.0.0/20"
  subnet_services_cidr = "10.80.16.0/20"
  subnet_pods_cidr     = "10.80.32.0/19"
  zones                = ["us-east1-a", "us-east1-b", "us-east1-c"]
  
  additional_main_subnet_cidrs = [
    {
      name = "extra-secondary-range-1"
      cidr = "10.81.0.0/20"
    }
  ]

  additional_subnets = [
    {
      name = "extra-subnet-1"
      cidr = "10.82.0.0/20"
    }
  ]
  
  additional_service_accounts = [
    {
      name = "extra-service-account-1"
      roles = ["roles/storage.admin"]
    }
  ]
  
  cluster_name         = "demo-cluster"
  cluster_resource_labels = {
    owner = "team-A"
  }

  node_pools = [
    {
      name = "flex-node-pool"
      autoscaling = true
      min_node_count = 1
      max_node_count = 3
      location_policy = "BALANCED"
      enable_private_nodes = true
      preemptible = false
      machine_type = "e2-medium"
      disk_size_gb = 100
      disk_type = "pd-standard"
      tags = "tag-1,tag-2"
    },
    {
      name = "static-node-pool"
      autoscaling = false
      node_count  = 2
    }
  ]

  node_pool_labels =
}
```

## Examples

There are more detailed examples inside the `examples/` directory.
- [basic_public_cluster](https://github.com/jpaulodit/terraform-google-abridge-env/tree/main/examples/basic_public_cluster)
- [basic_private_cluster](https://github.com/jpaulodit/terraform-google-abridge-env/tree/main/examples/basic_private_cluster)
- basic_private_cluster_with_multiple_node_pools

## Contributing

This project uses [pre-commit](https://pre-commit.com/) for documentation and code formatting. 
Please install pre-commit and run `pre-commit install` in the root of the repository before making any changes.

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
| [google_compute_router.cloud_router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) | resource |
| [google_compute_router_nat.cloud_nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) | resource |
| [google_compute_subnetwork.additional_subnets](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_compute_subnetwork.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_container_cluster.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_project_iam_member.additional_service_account_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.node_sa_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.additional_service_accounts](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account.nodes_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [random_shuffle.available_zones](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [google_compute_regions.available](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_regions) | data source |
| [google_compute_zones.zones](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |
| [google_service_account.lookup](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_main_subnet_cidrs"></a> [additional\_main\_subnet\_cidrs](#input\_additional\_main\_subnet\_cidrs) | Additional secondary ip ranges for the main subnet | <pre>list(object({<br/>    name = string<br/>    cidr = string<br/>  }))</pre> | `[]` | no |
| <a name="input_additional_node_sa_roles"></a> [additional\_node\_sa\_roles](#input\_additional\_node\_sa\_roles) | Additional roles to add to the nodes service account | `list(string)` | `[]` | no |
| <a name="input_additional_service_accounts"></a> [additional\_service\_accounts](#input\_additional\_service\_accounts) | Additional service accounts to create | <pre>list(object({<br/>    name  = string<br/>    roles = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_additional_subnets"></a> [additional\_subnets](#input\_additional\_subnets) | Additional subnets to create | <pre>list(object({<br/>    name = string<br/>    cidr = string<br/>  }))</pre> | `[]` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster | `string` | `"default"` | no |
| <a name="input_cluster_regional"></a> [cluster\_regional](#input\_cluster\_regional) | Cluster is regional if true (recommended), zonal if false | `bool` | `true` | no |
| <a name="input_cluster_resource_labels"></a> [cluster\_resource\_labels](#input\_cluster\_resource\_labels) | Key-value pairs to be added to the cluster | `map(string)` | `{}` | no |
| <a name="input_enable_iap_ssh"></a> [enable\_iap\_ssh](#input\_enable\_iap\_ssh) | Whether to enable IAP SSH access to the nodes | `bool` | `false` | no |
| <a name="input_enable_l4_ilb_subsetting"></a> [enable\_l4\_ilb\_subsetting](#input\_enable\_l4\_ilb\_subsetting) | Whether to enable L4 ILB subsetting | `bool` | `true` | no |
| <a name="input_enable_private_cluster_access_internet"></a> [enable\_private\_cluster\_access\_internet](#input\_enable\_private\_cluster\_access\_internet) | Whether to enable private cluster to have internet access | `bool` | `false` | no |
| <a name="input_enable_private_endpoint"></a> [enable\_private\_endpoint](#input\_enable\_private\_endpoint) | Whether to enable private endpoint | `bool` | `false` | no |
| <a name="input_enable_private_nodes"></a> [enable\_private\_nodes](#input\_enable\_private\_nodes) | Whether to enable private nodes | `bool` | `false` | no |
| <a name="input_enable_vertical_pod_autoscaler"></a> [enable\_vertical\_pod\_autoscaler](#input\_enable\_vertical\_pod\_autoscaler) | Whether to enable pod vertical pod autoscaler in the cluster | `bool` | `false` | no |
| <a name="input_node_pool_k8s_labels"></a> [node\_pool\_k8s\_labels](#input\_node\_pool\_k8s\_labels) | Key-value pairs to be added to the node pools | `map(map(string))` | `{}` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | List of maps containing node pools configurations | `list(map(any))` | <pre>[<br/>  {<br/>    "name": "default-node-pool"<br/>  }<br/>]</pre> | no |
| <a name="input_private_ip_google_access"></a> [private\_ip\_google\_access](#input\_private\_ip\_google\_access) | Whether to enable private IP Google access for the subnet | `bool` | `true` | no |
| <a name="input_private_master_cidrs"></a> [private\_master\_cidrs](#input\_private\_master\_cidrs) | List of CIDRs from which access to the control plane is allowed. This kicks in when enable\_private\_endpoint is true. If none is provided, only access from the cluster node IPs is allowed. | <pre>list(object({<br/>    cidr_block   = string,<br/>    display_name = string<br/>  }))</pre> | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for the cluster. | `string` | n/a | yes |
| <a name="input_ssh_tag"></a> [ssh\_tag](#input\_ssh\_tag) | The tag to use for the SSH access to the nodes. Nodes with this tag will have SSH access rules applied to them. | `string` | `"allow-ssh"` | no |
| <a name="input_subnet_pods_cidr"></a> [subnet\_pods\_cidr](#input\_subnet\_pods\_cidr) | The pods CIDR block for the subnet. Eg: 10.80.32.0/19 | `string` | n/a | yes |
| <a name="input_subnet_primary_cidr"></a> [subnet\_primary\_cidr](#input\_subnet\_primary\_cidr) | The primary CIDR block for the subnet. Eg: 10.80.0.0/20 | `string` | n/a | yes |
| <a name="input_subnet_services_cidr"></a> [subnet\_services\_cidr](#input\_subnet\_services\_cidr) | The services CIDR block for the subnet. Eg: 10.80.16.0/20 | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC | `string` | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | The zones to host the cluster in. If you want a zonal cluster, specify a single zone. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the cluster |
| <a name="output_gke_main_nodepool_id"></a> [gke\_main\_nodepool\_id](#output\_gke\_main\_nodepool\_id) | GKE Main Node Pool ID |
| <a name="output_gke_main_nodepool_version"></a> [gke\_main\_nodepool\_version](#output\_gke\_main\_nodepool\_version) | GKE Main Node Pool version |
| <a name="output_node_locations"></a> [node\_locations](#output\_node\_locations) | The locations of the nodes |
| <a name="output_node_service_account_email"></a> [node\_service\_account\_email](#output\_node\_service\_account\_email) | The email address of the service account |
<!-- END_TF_DOCS -->
