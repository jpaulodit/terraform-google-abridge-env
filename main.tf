resource "random_shuffle" "available_zones" {
  count        = local.zone_count == 0 ? 1 : 0
  input        = data.google_compute_zones.zones[0].names
  result_count = 3
}

locals {
  zone_count     = length(var.zones)
  location       = var.cluster_regional ? var.region : var.zones[0] # If regional, use the region, otherwise use the first zone.
  node_locations = var.cluster_regional ? coalescelist(compact(var.zones), try(sort(random_shuffle.available_zones[0].result), [])) : slice(var.zones, 1, length(var.zones))
  network_tag    = "gke-${var.cluster_name}-node"
}

resource "google_container_cluster" "main" {
  name    = var.cluster_name
  project = var.project_id

  # Regional or zonal cluster
  location       = local.location
  node_locations = local.node_locations

  # Making internal lb send traffic more efficiently 
  enable_l4_ilb_subsetting = var.enable_l4_ilb_subsetting

  # We want to manage our own node pool, but we cannot create a cluster with no node pools.
  # So we create a node pool with 1 node and then remove it.
  remove_default_node_pool = true
  initial_node_count       = 1

  # Enable workload identity. 
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  network    = google_compute_network.vpc_network.id
  subnetwork = google_compute_subnetwork.main.id
  ip_allocation_policy {
    services_secondary_range_name = google_compute_subnetwork.main.secondary_ip_range[0].range_name
    cluster_secondary_range_name  = google_compute_subnetwork.main.secondary_ip_range[1].range_name
  }

  resource_labels = var.cluster_resource_labels

  # Disable deletion protection so we can delete the cluster after exercise
  deletion_protection = false
}

resource "google_container_node_pool" "main" {
  for_each = { for np in var.node_pools : np.name => np }
  name     = "${each.value.name}-${random_id.nodes_sa_id.hex}"
  cluster  = google_container_cluster.main.name

  # Autoscaling is enabled by default.
  node_count = lookup(each.value, "autoscaling", true) ? null : lookup(each.value, "node_count", 1)

  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
    content {
      min_node_count = lookup(autoscaling.value, "min_node_count", 1)
      max_node_count = lookup(autoscaling.value, "max_node_count", 100)
    }
  }

  node_config {
    preemptible     = lookup(each.value, "preemptible", false)
    machine_type    = lookup(each.value, "machine_type", "e2-medium")
    service_account = lookup(each.value, "service_account", google_service_account.nodes_sa[0].email)
    tags            = lookup(each.value, "tags", null) != null ? concat(split(",", lookup(each.value, "tags")), [local.network_tag]) : [local.network_tag]
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# TODO: Create GKE cluster
# TODO: Flag to enable/disable control plane endpoint
# 3 types of subnets:
# - Public
# - Private
# - Private with egress to the public internet

# TODO: Create a NAT gateway
# TODO: Create a firewall rule to allow traffic from the NAT gateway to the public internet
# TODO: Create a firewall rule to allow traffic from the control plane to the public internet
# TODO: Create a firewall rule to allow traffic from the control plane to the private network
# TODO: Create a firewall rule to allow traffic from the private network to the control plane
# TODO: Create a firewall rule to allow traffic from the private network to the public internet

# TODO: Create a custom service account for the nodes in the GKE cluster

