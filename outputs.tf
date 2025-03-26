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
