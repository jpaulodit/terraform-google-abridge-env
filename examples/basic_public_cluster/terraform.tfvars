# Networking
region               = "us-east1"
subnet_primary_cidr  = "10.80.0.0/20"
subnet_services_cidr = "10.80.16.0/20"
subnet_pods_cidr     = "10.80.32.0/19"

# Cluster configuration
cluster_regional = true

enable_private_nodes = false

node_pools = [
  {
    name                 = "public-node-pool"
    machine_type         = "e2-medium"
    autoscaling          = true
    min_node_count       = 3
    max_node_count       = 9
    tags                 = "public-nodes-tag1,public-nodes-tag2"
    enable_private_nodes = false # Launch nodes with public IP addresses
  }
]

enable_private_cluster_access_internet = false
