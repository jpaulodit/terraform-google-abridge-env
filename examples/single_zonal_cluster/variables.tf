variable "project_id" {
  description = "The GCP project ID. Eg: learn-gke-454605-f0"
}

variable "region" {
  description = "The GCP region for the cluster. If cluster is regional, specify the region."
  default     = "us-east1"
}
