module "basic_public_cluster" {
  source = "../../"

  project_id                      = var.project_id
  cluster_regional                = var.cluster_regional
  region                          = var.region
  zones                           = var.zones
  vpc_name                        = var.vpc_name
  subnet_primary_cidr             = var.subnet_primary_cidr
  subnet_services_cidr            = var.subnet_services_cidr
  subnet_pods_cidr                = var.subnet_pods_cidr
  cluster_name                    = var.cluster_name
  node_pools                      = var.node_pools
  enable_private_nodes            = var.enable_private_nodes
  enable_private_endpoint         = var.enable_private_endpoint
  private_master_cidrs            = var.private_master_cidrs
  enable_private_cluster_internet = var.enable_private_cluster_internet
  enable_iap_ssh                  = true
}
