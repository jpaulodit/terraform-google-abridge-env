# Networking
region               = "us-east1"
subnet_primary_cidr  = "10.80.0.0/20"
subnet_services_cidr = "10.80.16.0/20"
subnet_pods_cidr     = "10.80.32.0/19"

# Cluster configuration
cluster_regional = true

node_pools = [
  {
    name         = "private-node-pool"
    machine_type = "e2-medium"
    autoscaling  = false
    node_count   = 2
    tags         = "private-nodes"
  }
]

enable_private_cluster_access_internet = true
