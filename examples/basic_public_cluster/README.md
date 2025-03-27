Creates a GKE cluster

- regional cluster
- in us-east1
- in 3 zones
- 1 node pool
- auto scaling set to false
- 1 node per zone
- every node gets a public ip and private ip
- 
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
| <a name="module_basic_public_cluster"></a> [basic\_public\_cluster](#module\_basic\_public\_cluster) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the cluster | `any` | n/a | yes |
| <a name="input_cluster_regional"></a> [cluster\_regional](#input\_cluster\_regional) | Whether the cluster is regional or zonal. If regional, specify the region. | `any` | n/a | yes |
| <a name="input_enable_iap_ssh"></a> [enable\_iap\_ssh](#input\_enable\_iap\_ssh) | Whether to enable IAP SSH access to the nodes | `any` | n/a | yes |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | List of maps containing node pools configurations | `list(map(any))` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The GCP region for the cluster. If cluster is regional, specify the region. | `any` | n/a | yes |
| <a name="input_subnet_pods_cidr"></a> [subnet\_pods\_cidr](#input\_subnet\_pods\_cidr) | The pods CIDR block for the subnet. Eg: 10.80.32.0/19 | `any` | n/a | yes |
| <a name="input_subnet_primary_cidr"></a> [subnet\_primary\_cidr](#input\_subnet\_primary\_cidr) | The primary CIDR block for the subnet. Eg: 10.80.0.0/20 | `any` | n/a | yes |
| <a name="input_subnet_services_cidr"></a> [subnet\_services\_cidr](#input\_subnet\_services\_cidr) | The services CIDR block for the subnet. Eg: 10.80.16.0/20 | `any` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
