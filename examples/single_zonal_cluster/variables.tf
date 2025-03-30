variable "project_id" {
  description = "The GCP project ID. Eg: learn-gke-454605-f0"
  type        = string
}

variable "region" {
  description = "The GCP region for the cluster. If cluster is regional, specify the region."
  type        = string
}

variable "zones" {
  description = "The GCP zones for the zonal cluster"
  type        = list(string)
}

variable "cluster_regional" {
  description = "Whether the cluster is regional or zonal. If regional, specify the region."
}

variable "subnet_primary_cidr" {
  description = "The primary CIDR block for the subnet"
  type        = string
}

variable "subnet_services_cidr" {
  description = "The services CIDR block for the subnet"
  type        = string
}

variable "subnet_pods_cidr" {
  description = "The pods CIDR block for the subnet"
  type        = string
}

variable "node_pools" {
  type        = list(map(any))
  description = "List of maps containing node pools configurations"
}

variable "enable_private_cluster_access_internet" {
  description = "Whether to enable private cluster to have internet access"
  type        = bool
}

variable "private_master_cidrs" {
  description = "List of CIDRs from which access to the control plane is allowed"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
}
