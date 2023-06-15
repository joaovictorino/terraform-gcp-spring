output "public_ip_address_app" {
  value = "http://${google_compute_address.ip-aula.address}:8080"
}
