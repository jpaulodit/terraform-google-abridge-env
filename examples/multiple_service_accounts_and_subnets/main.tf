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
    prefix = "terraform/state/multiple_service_accounts_and_subnets"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "gke" {
  # source = "git@github.com:jpaulodit/terraform-google-abridge-env.git"
  source = "git::https://github.com/jpaulodit/terraform-google-abridge-env.git"
  
  project_id           = var.project_id
  region               = var.region
  subnet_primary_cidr  = "10.80.0.0/20"
  subnet_services_cidr = "10.80.16.0/20"
  subnet_pods_cidr     = "10.80.32.0/19"
  zones                = ["us-east1-b", "us-east1-c", "us-east1-d"]

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

  # Creates another service account with a specific role(s)
  additional_service_accounts = [
    {
      name  = "extra-service-account-1"
      roles = ["roles/container.defaultNodeServiceAccount"]
    }
  ]

  cluster_resource_labels = {
    owner = "team-infrastructure"
  }

  enable_private_nodes                   = true
  enable_private_endpoint                = true
  enable_vertical_pod_autoscaler         = true
  enable_private_cluster_access_internet = true

  node_pools = [
    {
      name                 = "flex-node-pool"
      autoscaling          = true
      min_node_count       = 1
      max_node_count       = 3
      location_policy      = "BALANCED"
      enable_private_nodes = true
      preemptible          = false
      machine_type         = "e2-medium"
      disk_size_gb         = 100
      disk_type            = "pd-standard"
      tags                 = "tag-1,tag-2"
    },
    {
      name        = "static-node-pool"
      autoscaling = false
      node_count  = 2
      # Assign to the node pool the service account created above
      service_account = "extra-service-account-1"
    }
  ]
}
