# Output the email for use in other resources
output "node_service_account_email" {
  description = "The email address of the service account"
  value       = google_service_account.nodes_sa.email
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
  value       = { for k, v in google_container_node_pool.main : k => v.id }
}

output "gke_main_nodepool_version" {
  description = "GKE Main Node Pool version"
  value       = { for k, v in google_container_node_pool.main : k => v.version }
}
