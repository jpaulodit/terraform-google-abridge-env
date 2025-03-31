variable "project_id" {
  description = "The GCP project ID. Eg: abridge-hw"
  type        = string
}

variable "region" {
  description = "The GCP region for the cluster. If cluster is regional, specify the region."
  type        = string
  default     = "us-east1"
}

