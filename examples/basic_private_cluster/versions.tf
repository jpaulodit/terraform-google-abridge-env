terraform {
  required_version = ">= 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
  backend "gcs" {
    bucket = var.state_bucket_name
    prefix = "terraform/state/basic_private_cluster"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}