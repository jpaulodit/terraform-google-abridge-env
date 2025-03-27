project_id = "learn-gke-454605-f0"

# Networking
vpc_name             = "public-cluster"
region               = "us-east1"
subnet_primary_cidr  = "10.80.0.0/20"
subnet_services_cidr = "10.80.16.0/20"
subnet_pods_cidr     = "10.80.32.0/19"

# Cluster configuration
cluster_regional = true
cluster_name     = "public-cluster"
node_pools = [
  {
    name         = "default-node-pool"
    machine_type = "e2-medium"
    node_count   = 1
    autoscaling  = false
    tags         = "tag-1,tag-2"
  }
]
