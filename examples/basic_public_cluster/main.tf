terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
  backend "gcs" {
    bucket = "tf-state-bucket-learn-gke-454605-f0"
    prefix = "terraform/state/basic_public_cluster"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "basic_public_cluster" {
  source = "git@github.com:jpaulodit/terraform-google-abridge-env.git"

  cluster_name                           = "basic-public-cluster"
  vpc_name                               = "basic-public-cluster-vpc"
  project_id                             = var.project_id
  cluster_regional                       = var.cluster_regional
  region                                 = var.region
  subnet_primary_cidr                    = var.subnet_primary_cidr
  subnet_services_cidr                   = var.subnet_services_cidr
  subnet_pods_cidr                       = var.subnet_pods_cidr
  enable_private_nodes                   = var.enable_private_nodes
  node_pools                             = var.node_pools
  enable_private_cluster_access_internet = var.enable_private_cluster_access_internet
}
