# Network Configuration
region               = "us-east1"
zones                = ["us-east1-b"]
subnet_primary_cidr  = "10.80.0.0/20"
subnet_services_cidr = "10.80.16.0/20"
subnet_pods_cidr     = "10.80.32.0/19"

# Cluster configuration
cluster_regional = false

node_pools = [
  {
    name         = "private-node-pool"
    machine_type = "e2-medium"
    autoscaling  = false
    node_count   = 1
    tags         = "private-nodes"
  }
]

private_master_cidrs = [
  {
    cidr_block   = "0.0.0.0/0"
    display_name = "Allow all"
  }
]
enable_private_cluster_access_internet = true
