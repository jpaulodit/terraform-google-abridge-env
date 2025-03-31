# Network Configuration
region               = "us-east1"
zones                = ["us-east1-b", "us-east1-c"]
subnet_primary_cidr  = "10.80.0.0/20"
subnet_services_cidr = "10.80.16.0/20"
subnet_pods_cidr     = "10.80.32.0/19"

# Cluster configuration
cluster_regional = false

node_pools = [
  {
    name           = "private-node-pool-a"
    machine_type   = "e2-medium"
    autoscaling    = true
    min_node_count = 1
    max_node_count = 3
    disk_type      = "pd-balanced"
    disk_size_gb   = 50
    tags           = "private-nodes,medium-workload"
  },
  {
    name            = "private-node-pool-b"
    machine_type    = "e2-small"
    autoscaling     = true
    min_node_count  = 2
    max_node_count  = 4
    location_policy = "ANY"
    tags            = "private-nodes,small-workload"
  },
  {
    name           = "private-node-pool-c"
    machine_type   = "e2-medium"
    autoscaling    = false
    node_count     = 1
    node_locations = "us-east1-d" # this wasn't part of the zone list
    tags           = "private-nodes,medium-workload"
  }
]

node_pool_k8s_labels = {
  private-node-pool-a = {
    purpose = "demo"
  }
  private-node-pool-c = {
    purpose = "outside_zone"
  }
}

private_master_cidrs = [
  {
    cidr_block   = "0.0.0.0/0"
    display_name = "Allow all"
  }
]
enable_private_cluster_access_internet = true
