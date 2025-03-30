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
    prefix = "terraform/state/single_zonal_cluster"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "single_zonal_cluster" {
  source = "git@github.com:jpaulodit/terraform-google-abridge-env.git"

  project_id           = var.project_id
  cluster_regional     = false
  region               = var.region
  zones                = ["us-east1-b", "us-east1-c"]
  subnet_primary_cidr  = "10.80.0.0/20"
  subnet_services_cidr = "10.80.16.0/20"
  subnet_pods_cidr     = "10.80.32.0/19"
  node_pools = [
    {
      name         = "private-node-pool"
      machine_type = "e2-medium"
      autoscaling  = false
      node_count   = 2
      tags         = "private-nodes"
    }
  ]
  enable_private_cluster_access_internet = true
  private_master_cidrs = [
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "Allow all"
    }
  ]
}
