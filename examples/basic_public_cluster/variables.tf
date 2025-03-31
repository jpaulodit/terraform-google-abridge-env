variable "project_id" {
  description = "The GCP project ID. Eg: learn-gke-454605-f0"
  type        = string
}

variable "region" {
  description = "The GCP region for the cluster. If cluster is regional, specify the region."
  type        = string
}

variable "cluster_regional" {
  description = "Whether the cluster is regional or zonal. If regional, specify the region."
}

variable "subnet_primary_cidr" {
  description = "The primary CIDR block for the subnet. Eg: 10.80.0.0/20"
}

variable "subnet_services_cidr" {
  description = "The services CIDR block for the subnet. Eg: 10.80.16.0/20"
}

variable "subnet_pods_cidr" {
  description = "The pods CIDR block for the subnet. Eg: 10.80.32.0/19"
}

variable "node_pools" {
  type        = list(map(any))
  description = "List of maps containing node pools configurations"
}

variable "enable_private_nodes" {
  description = "Whether to enable private nodes"
}

variable "enable_private_cluster_access_internet" {
  description = "Whether to enable private cluster access to the internet"
}
