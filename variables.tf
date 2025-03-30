variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "subnet_primary_cidr" {
  description = "The primary CIDR block for the subnet. Eg: 10.80.0.0/20"
  type        = string
}

variable "subnet_services_cidr" {
  description = "The services CIDR block for the subnet. Eg: 10.80.16.0/20"
  type        = string
}

variable "subnet_pods_cidr" {
  description = "The pods CIDR block for the subnet. Eg: 10.80.32.0/19"
  type        = string
}

variable "private_ip_google_access" {
  description = "Whether to enable private IP Google access for the subnet"
  type        = bool
  default     = true
}

variable "additional_main_subnet_cidrs" {
  description = "Additional secondary ip ranges for the main subnet"
  type = list(object({
    name = string
    cidr = string
  }))
  default = []
}

variable "additional_subnets" {
  description = "Additional subnets to create"
  type = list(object({
    name = string
    cidr = string
  }))
  default = []
}

variable "cluster_regional" {
  description = "Cluster is regional if true (recommended), zonal if false"
  type        = bool
  default     = true
}

variable "region" {
  description = "The GCP region for the cluster."
  type        = string
  validation {
    condition = contains([
      "us-east1", "us-east4", "us-central1", "us-west1", "us-west2",
      "europe-west1", "europe-west2", "europe-west3",
      "asia-east1", "asia-east2", "asia-southeast1",
      "southamerica-east1"
    ], var.region)
    error_message = "Invalid region defined. Please specify a valid GCP region."
  }
}

variable "zones" {
  description = "The zones to host the cluster in. If you want a zonal cluster, specify a single zone."
  type        = list(string)
  default     = []
  validation {
    condition     = var.cluster_regional ? true : length(var.zones) > 0
    error_message = "Zones must be specified for zonal clusters."
  }
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "default"
}

variable "additional_node_sa_roles" {
  description = "Additional roles to add to the nodes service account"
  type        = list(string)
  default     = []
}

variable "additional_service_accounts" {
  description = "Additional service accounts to create"
  type = list(object({
    name  = string
    roles = list(string)
  }))
  default = []
}

variable "enable_l4_ilb_subsetting" {
  description = "Whether to enable L4 ILB subsetting"
  type        = bool
  default     = true
}

variable "cluster_resource_labels" {
  description = "Key-value pairs to be added to the cluster"
  type        = map(string)
  default     = {}
}

variable "node_pools" {
  type        = list(map(any))
  description = "List of maps containing node pools configurations"
  default = [
    {
      name = "default-node-pool"
    },
  ]
}

variable "node_pool_k8s_labels" {
  type        = map(map(string))
  description = "Key-value pairs to be added to the node pools"
  default     = {}
}

variable "enable_private_nodes" {
  description = "Whether to enable private nodes"
  type        = bool
  default     = false
}

variable "enable_private_endpoint" {
  description = "Whether to enable private endpoint"
  type        = bool
  default     = false
}

variable "enable_vertical_pod_autoscaler" {
  description = "Whether to enable pod vertical pod autoscaler in the cluster"
  type        = bool
  default     = false
}

variable "private_master_cidrs" {
  type = list(object({
    cidr_block   = string,
    display_name = string
  }))
  description = "List of CIDRs from which access to the control plane is allowed. This kicks in when enable_private_endpoint is true. If none is provided, only access from the cluster node IPs is allowed."
  default     = []
}

variable "enable_iap_ssh" {
  description = "Whether to enable IAP SSH access to the nodes"
  type        = bool
  default     = false
}

variable "enable_private_cluster_access_internet" {
  description = "Whether to enable private cluster to have internet access"
  type        = bool
  default     = false
}
