resource "google_compute_network" "vpc_network" {
  name                            = "quickstart-network"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = true
  depends_on = [
    google_project_service.compute_service
  ]
}

resource "google_compute_subnetwork" "quickstart_private_subnet" {
  name          = "quickstart-private-subnet"
  ip_cidr_range = "10.2.0.0/16"
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_subnetwork" "quickstart_public_subnet" {
  name          = "quickstart-public-subnet"
  ip_cidr_range = "10.4.0.0/16"
  network       = google_compute_network.vpc_network.self_link
}


resource "google_compute_route" "quickstart_network_internet_route" {
  name             = "quickstart-network-internet"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.vpc_network.self_link
  next_hop_gateway = "default-internet-gateway"
  priority         = 100
}

resource "google_compute_router" "router" {
  name    = "quickstart-router"
  network = google_compute_network.vpc_network.self_link
}

resource "google_compute_router_nat" "nat" {
  name                               = "quickstart-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
