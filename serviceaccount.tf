# Service account for GKE nodes with minimum required permissions
resource "google_service_account" "nodes_sa" {
  project      = var.project_id
  account_id   = "${var.cluster_name}-nodes-sa"
  display_name = "GKE Nodes Service Account for ${var.cluster_name}"
  description  = "Service account used by GKE nodes for system operations"
}

# Grant the service account the necessary roles
locals {
  # Roles required for GKE node operations
  default_node_sa_roles = [
    "roles/container.defaultNodeServiceAccount",
    # Roles for logging and monitoring
    "roles/monitoring.metricWriter",
    "roles/logging.logWriter",
    "roles/stackdriver.resourceMetadata.writer",
    # Roles for container operations
    "roles/artifactregistry.reader",
    "roles/storage.objectViewer",
    # Role for service usage
    "roles/serviceusage.serviceUsageConsumer"
  ]

  node_sa_roles = concat(local.default_node_sa_roles, var.additional_node_sa_roles)
}

resource "google_project_iam_member" "node_sa_roles" {
  for_each = toset(local.node_sa_roles)
  project  = var.project_id
  role     = each.value
  member   = google_service_account.nodes_sa.member
}


# Create additional service accounts if specified
resource "google_service_account" "additional_service_accounts" {
  for_each     = { for sa in var.additional_service_accounts : sa.name => sa }
  project      = var.project_id
  account_id   = each.value.name
  display_name = each.value.name
  description  = "Service account for ${each.value.name}"
}

resource "google_project_iam_member" "additional_service_account_roles" {
  for_each = {
    for pair in flatten([
      for sa in var.additional_service_accounts : [
        for role in sa.roles : {
          sa_name = sa.name
          role    = role
        }
      ]
    ]) : "${pair.sa_name}-${pair.role}" => pair
  }
  project = var.project_id
  role    = each.value.role
  member  = google_service_account.additional_service_accounts[each.value.sa_name].member
}

