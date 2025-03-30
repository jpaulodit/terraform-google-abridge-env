This directory contains an example for a basic private cluster. There are variables set inside terraform.tfvars.

To try out this example, run the following commands in this directory

- `terraform init` - to initialize the working directory and download any modules, plugins, etc...
- `terraform plan -out=tfplan` - to see the changes that will be made
- `terraform apply tfplan` - to apply the changes
- `terraform destroy` - to destroy and clean up the work

This creates
- 1 VPC and 1 subnet.
- 1 zonal GKE cluster in us-east1-b. Private nodes is enabled so all provisioned nodes are assigned only private IPs.
- The controlplane endpoint access from the internet is restricted to an IP address.
- 1 custom service account is created for the nodes.
- 1 node pool with autoscaling set to true, with a minimum node count of 1 and a maximum node count of 3.
- adds labels to the node

## Inputs 

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
  project = "learn-gke-454605-f0" # set this to your own project ID.
  region  = "us-east1-b"
}

module "private-cluster" {
    source = "git@github.com:jpaulodit/terraform-google-abridge-env.git"

    project_id = "learn-gke-454605-f0"  # Set this to your own project ID

    # Networking
    vpc_name             = "private-vpc"
    region               = "us-east1"
    subnet_primary_cidr  = "10.80.0.0/20"
    subnet_services_cidr = "10.80.16.0/20"
    subnet_pods_cidr     = "10.80.32.0/19"

    # Cluster configuration
    cluster_regional = true
    zones            = ["us-east1-b"]
    cluster_name     = "private-cluster"
    node_pools = [
      {
        name         = "private-node-pool"
        machine_type = "e2-medium"
        autoscaling  = true
      }
    ]
}
```




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
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID. Eg: learn-gke-454605-f0 | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for the cluster. If cluster is regional, specify the region. | `any` | n/a | yes |
| <a name="input_subnet_pods_cidr"></a> [subnet\_pods\_cidr](#input\_subnet\_pods\_cidr) | The pods CIDR block for the subnet. Eg: 10.80.32.0/19 | `any` | n/a | yes |
| <a name="input_subnet_primary_cidr"></a> [subnet\_primary\_cidr](#input\_subnet\_primary\_cidr) | The primary CIDR block for the subnet. Eg: 10.80.0.0/20 | `any` | n/a | yes |
| <a name="input_subnet_services_cidr"></a> [subnet\_services\_cidr](#input\_subnet\_services\_cidr) | The services CIDR block for the subnet. Eg: 10.80.16.0/20 | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
