module "basic_public_cluster" {
  source = "../../"

  project_id           = var.project_id
  cluster_regional     = var.cluster_regional
  region               = var.region
  vpc_name             = var.vpc_name
  subnet_primary_cidr  = var.subnet_primary_cidr
  subnet_services_cidr = var.subnet_services_cidr
  subnet_pods_cidr     = var.subnet_pods_cidr
  cluster_name         = var.cluster_name
  node_pools           = var.node_pools
  enable_iap_ssh       = var.enable_iap_ssh
}