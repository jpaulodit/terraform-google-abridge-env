variable "project_id" {
  description = "The GCP project ID. Eg: abridge-hw"
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

variable "node_pools" {
  type        = list(map(any))
  description = "List of maps containing node pools configurations"
}

variable "enable_private_cluster_access_internet" {
  description = "Whether to enable private cluster to have internet access"
}

variable "private_master_cidrs" {
  type = list(object({
    cidr_block   = string,
    display_name = string
  }))
  description = "List of CIDRs from which access to the control plane is allowed. This kicks in when enable_private_endpoint is true. If none is provided, only access from the cluster node IPs is allowed."
}
