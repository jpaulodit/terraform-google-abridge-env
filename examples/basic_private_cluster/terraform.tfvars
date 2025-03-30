project_id = "learn-gke-454605-f0"

# Networking
vpc_name             = "private-vpc"
region               = "us-east1"
subnet_primary_cidr  = "10.80.0.0/20"
subnet_services_cidr = "10.80.16.0/20"
subnet_pods_cidr     = "10.80.32.0/19"

# Cluster configuration
cluster_regional        = false
zones                   = ["us-east1-b"]
cluster_name            = "private-cluster"
enable_private_nodes    = true
enable_private_endpoint = false
private_master_cidrs = [{
  cidr_block   = "0.0.0.0/0",
  display_name = "expose-to-internet"
}]

node_pools = [
  {
    name            = "private-node-pool"
    machine_type    = "e2-medium"
    autoscaling     = true
    min_node_count  = 1
    max_node_count  = 3
    location_policy = "BALANCED"
    tags            = "private-nodes"
  },
  {
    name            = "private-node-pool-2"
    machine_type    = "e2-medium"
    autoscaling     = true
    min_node_count  = 1
    max_node_count  = 3
    service_account = "private-node-pool-sa-3"
  }
]

node_pool_k8s_labels = {
  "private-node-pool" = {
    environment = "private"
    node_type   = "worker"
  }
}

enable_private_cluster_internet = true
