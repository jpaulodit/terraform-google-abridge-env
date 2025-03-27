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
  description = "The GCP region for the cluster. If cluster is regional, specify the region."
  type        = string
  default     = "us-east1"
}

variable "zones" {
  description = "The zones to host the cluster in. If you want a zonal cluster, specify a single zone."
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "default"
}

variable "autopilot" {
  description = "Whether to enable autopilot for the cluster"
  type        = bool
  default     = false
}

variable "create_nodes_service_account" {
  description = "Whether to create a service account for the nodes in the GKE cluster"
  type        = bool
  default     = true
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
  description = "List of maps containing node pools configurations. Autoscaling is enabled by default."

  default = [
    {
      name = "default-node-pool"
    },
  ]
}

variable "enable_iap_ssh" {
  description = "Whether to enable IAP SSH access to the nodes"
  type        = bool
  default     = false
}
