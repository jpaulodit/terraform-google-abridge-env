terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
  backend "gcs" {
    bucket = "tf-state-bucket-abridge-hw"
    prefix = "terraform/state/single_zonal_private_cluster"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "multi_zonal_private_cluster" {
  source = "git@github.com:jpaulodit/terraform-google-abridge-env.git"

  project_id                             = var.project_id
  cluster_regional                       = var.cluster_regional
  region                                 = var.region
  zones                                  = var.zones
  subnet_primary_cidr                    = var.subnet_primary_cidr
  subnet_services_cidr                   = var.subnet_services_cidr
  subnet_pods_cidr                       = var.subnet_pods_cidr
  node_pools                             = var.node_pools
  enable_private_cluster_access_internet = var.enable_private_cluster_access_internet
  private_master_cidrs                   = var.private_master_cidrs
  node_pool_k8s_labels                   = var.node_pool_k8s_labels
}
