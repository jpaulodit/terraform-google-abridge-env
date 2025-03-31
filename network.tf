resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "google_compute_network" "vpc_network" {
  name = "${var.vpc_name}-${random_string.suffix.result}"

  # When set to false, the network is created in "custom" mode, allowing for the creation
  # of custom subnetworks. If set to true, Google Cloud would automatically create a subnetwork
  # for each region. Using false gives us more control over our network architecture.
  auto_create_subnetworks = false

  # Enable internal IPv6 for the VPC. Default is false.
  enable_ula_internal_ipv6 = false
}

# Create a subnet.
resource "google_compute_subnetwork" "main" {
  name                     = "${var.vpc_name}-${random_string.suffix.result}"
  region                   = var.region
  ip_cidr_range            = var.subnet_primary_cidr
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = var.private_ip_google_access

  stack_type = "IPV4_ONLY"

  secondary_ip_range {
    range_name    = "${var.vpc_name}-main-services-range"
    ip_cidr_range = var.subnet_services_cidr # Services range: IPs for k8s services
  }

  secondary_ip_range {
    range_name    = "${var.vpc_name}-main-pods-range"
    ip_cidr_range = var.subnet_pods_cidr # Pods range: IPs for pods (larger range)
  }

  dynamic "secondary_ip_range" {
    for_each = var.additional_main_subnet_cidrs
    content {
      range_name    = secondary_ip_range.value.name
      ip_cidr_range = secondary_ip_range.value.cidr
    }
  }
}

resource "google_compute_subnetwork" "additional_subnets" {
  for_each      = { for subnet in var.additional_subnets : subnet.name => subnet }
  name          = "${var.vpc_name}-${each.value.name}"
  region        = var.region
  ip_cidr_range = each.value.cidr
  network       = google_compute_network.vpc_network.id
  stack_type    = "IPV4_ONLY"
}

# Allow SSH via Identity-Aware Proxy
resource "google_compute_firewall" "iap_ssh" {
  count   = var.enable_iap_ssh ? 1 : 0
  name    = "${var.vpc_name}-allow-iap-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Identity-Aware Proxy's IP range. This IP range is given by Google Cloud.
  source_ranges = ["35.235.240.0/20"]

  target_tags = [var.ssh_tag]
}

# Configure Cloud Router which will be used to group NAT configuration information
resource "google_compute_router" "cloud_router" {
  count   = var.enable_private_cluster_access_internet ? 1 : 0
  name    = "${var.vpc_name}-${var.region}-cloud-router"
  region  = var.region
  network = google_compute_network.vpc_network.id
}

# Configure Cloud NAT
resource "google_compute_router_nat" "cloud_nat" {
  count                              = var.enable_private_cluster_access_internet ? 1 : 0
  name                               = "${var.vpc_name}-${var.region}-cloud-nat"
  router                             = google_compute_router.cloud_router[0].name
  region                             = google_compute_router.cloud_router[0].region
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ip_allocate_option             = "AUTO_ONLY"
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
