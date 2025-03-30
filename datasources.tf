data "google_compute_regions" "available" {}

data "google_compute_zones" "zones" {
  count   = local.zone_count == 0 ? 1 : 0
  status  = "UP"
  region  = var.region
  project = var.project_id
}

data "google_service_account" "lookup" {
  for_each   = { for np in var.node_pools : np.name => np if lookup(np, "service_account", null) != null }
  account_id = each.value.service_account
  depends_on = [google_service_account.additional_service_accounts]
}
