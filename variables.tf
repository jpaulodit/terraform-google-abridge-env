variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "create_public_subnet" {
  description = "Whether to create a public subnet"
  type        = bool
  default     = true
}

variable "additional_private_subnet_cidrs" {
  description = "Additional secondary ip ranges for the private subnet"
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

variable "region" {
  description = "The GCP region for the cluster"
  type        = string
  default     = "us-east1"
}

variable "zones" {
  description = "The zones to host the cluster in. "
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "default-cluster"
}

variable "regional" {
  description = "Cluster is regional if true, zonal if false"
  type        = bool
  default     = true
}

variable "autopilot" {
  description = "Whether to enable autopilot for the cluster"
  type        = bool
  default     = false
}

