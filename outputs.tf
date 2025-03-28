# Output the email for use in other resources
output "node_service_account_email" {
  description = "The email address of the service account"
  value       = var.create_nodes_service_account ? google_service_account.nodes_sa[0].email : ""
}

output "cluster_name" {
  description = "The name of the cluster"
  value       = google_container_cluster.main.name
}

output "node_locations" {
  description = "The locations of the nodes"
  value       = local.node_locations
}

output "gke_main_nodepool_id" {
  description = "GKE Main Node Pool ID"
  value       = google_container_node_pool.main.id
}
output "gke_main_nodepool_version" {
  description = "GKE Main Node Pool version"
  value       = google_container_node_pool.main.version
}
