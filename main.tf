resource "random_shuffle" "available_zones" {
  count        = local.zone_count == 0 ? 1 : 0
  input        = data.google_compute_zones.zones[0].names
  result_count = 3
}


locals {
  zone_count       = length(var.zones)
  location         = var.cluster_regional ? var.region : var.zones[0] # If regional, use the region, otherwise use the first zone.
  node_locations   = var.cluster_regional ? coalescelist(compact(var.zones), try(sort(random_shuffle.available_zones[0].result), [])) : slice(var.zones, 1, length(var.zones))
  network_tag      = "gke-${var.cluster_name}-node"
  default_sa_email = google_service_account.nodes_sa.email
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

  # If user wants private cluster, we need to enable private nodes and private endpoint (maybe).
  # Enable private endpoint applies only when prviate nodes is enabled.
  dynamic "private_cluster_config" {
    for_each = var.enable_private_nodes ? [1] : []
    content {
      enable_private_nodes    = var.enable_private_nodes
      enable_private_endpoint = var.enable_private_endpoint
    }
  }

  # This is used to control which CIDRs can access the control plane.
  dynamic "master_authorized_networks_config" {
    for_each = var.enable_private_nodes || length(var.private_master_cidrs) > 0 ? [1] : []
    content {
      dynamic "cidr_blocks" {
        for_each = var.private_master_cidrs
        content {
          cidr_block   = cidr_blocks.value.cidr_block
          display_name = cidr_blocks.value.display_name
        }
      }
    }
  }

  resource_labels = var.cluster_resource_labels

  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaler
  }

  # Disable deletion protection so we can delete the cluster after exercise
  deletion_protection = false
}

resource "google_container_node_pool" "main" {
  for_each = { for np in var.node_pools : np.name => np }
  name     = each.value.name
  cluster  = google_container_cluster.main.name
  location = local.location

  node_locations = lookup(each.value, "node_locations", null) != null ? split(",", lookup(each.value, "node_locations")) : null

  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
    content {
      min_node_count  = lookup(autoscaling.value, "min_node_count", 1)
      max_node_count  = lookup(autoscaling.value, "max_node_count", 100)
      location_policy = lookup(autoscaling.value, "location_policy", null)
    }
  }

  network_config {
    enable_private_nodes = lookup(each.value, "enable_private_nodes", true)
  }

  node_config {
    preemptible  = lookup(each.value, "preemptible", false)
    machine_type = lookup(each.value, "machine_type", "e2-medium")
    service_account = lookup(each.value, "service_account", null) != null ? try(
      data.google_service_account.lookup[each.value.service_account].email,
      google_service_account.additional_service_accounts[each.value.service_account].email,
    ) : local.default_sa_email
    disk_size_gb = lookup(each.value, "disk_size_gb", 100)        # The smallest allowed disk size is 10GB
    disk_type    = lookup(each.value, "disk_type", "pd-standard") # Supported pd-standard, pd-balanced or pd-ssd, default is pd-standard    
    tags         = lookup(each.value, "tags", null) != null ? concat(split(",", lookup(each.value, "tags")), [local.network_tag]) : [local.network_tag]
    labels       = lookup(var.node_pool_k8s_labels, each.value.name, null)

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  depends_on = [
    google_service_account.additional_service_accounts,
    google_service_account.nodes_sa
  ]
}
