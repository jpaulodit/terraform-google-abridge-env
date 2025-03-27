data "google_compute_zones" "zones" {
  count   = local.zone_count == 0 ? 1 : 0
  status  = "UP"
  region  = var.region
  project = var.project_id
}
