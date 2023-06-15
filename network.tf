resource "google_compute_network" "vpc-aula" {
  name                    = "vpc-aula"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet-aula" {
  name          = "subnet-aula"
  ip_cidr_range = "10.80.4.0/24"
  region        = "us-central1"
  network       = google_compute_network.vpc-aula.id
}

resource "google_compute_firewall" "firewall-aula" {
  name          = "firewall-aula"
  network       = google_compute_network.vpc-aula.name
  target_tags   = ["allow-ssh"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22", "8080", "3306"]
  }
}
