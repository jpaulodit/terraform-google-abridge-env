project_id = "learn-gke-454605-f0"

# Networking
vpc_name             = "private-vpc"
region               = "us-east1"
subnet_primary_cidr  = "10.80.0.0/20"
subnet_services_cidr = "10.80.16.0/20"
subnet_pods_cidr     = "10.80.32.0/19"

# Cluster configuration
cluster_regional = false
zones            = ["us-east1-b"]
cluster_name     = "private-cluster"
node_pools = [
  {
    name         = "private-node-pool"
    machine_type = "e2-medium"
    node_count   = 1
    autoscaling  = false
  }
]

enable_private_nodes    = true
enable_private_endpoint = false
private_master_cidrs = [{
  cidr_block   = "98.41.59.48/32",
  display_name = "home-ip"
}]
enable_private_cluster_internet = true
