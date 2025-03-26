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
  ip_cidr_range            = "10.80.0.0/20" # Primary range: IPs for nodes
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true

  stack_type = "IPV4_ONLY"

  secondary_ip_range {
    range_name    = "${var.vpc_name}-private-services-range"
    ip_cidr_range = "10.80.16.0/20" # Services range: IPs for k8s services
  }

  secondary_ip_range {
    range_name    = "${var.vpc_name}-private-pods-range"
    ip_cidr_range = "10.80.32.0/19" # Pods range: IPs for pods (larger range)
  }

  dynamic "secondary_ip_range" {
    for_each = var.additional_private_subnet_cidrs
    content {
      range_name    = secondary_ip_range.value.name
      ip_cidr_range = secondary_ip_range.value.cidr
    }
  }
}

# # Create a public subnet. This will be used for workloads
# # like public facing load balancers.
# resource "google_compute_subnetwork" "public_subnet" {
#   count         = var.create_public_subnet ? 1 : 0
#   name          = "${var.vpc_name}-public"
#   region        = var.region
#   ip_cidr_range = "10.81.0.0/20"
#   network       = google_compute_network.vpc_network.id
#   stack_type    = "IPV4_ONLY"
# }

resource "google_compute_subnetwork" "additional_subnets" {
  for_each      = toset(var.additional_subnets)
  name          = "${var.vpc_name}-${each.value.name}"
  region        = var.region
  ip_cidr_range = each.value.cidr
  network       = google_compute_network.vpc_network.id
  stack_type    = "IPV4_ONLY"
}
