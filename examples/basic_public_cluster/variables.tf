variable "project_id" {
  description = "The GCP project ID"
}

variable "vpc_name" {
  description = "The name of the VPC"
}

variable "region" {
  description = "The GCP region for the cluster. If cluster is regional, specify the region."
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

variable "cluster_name" {
  description = "The name of the cluster"
}

variable "node_pools" {
  type        = list(map(any))
  description = "List of maps containing node pools configurations"
}
