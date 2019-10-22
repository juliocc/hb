output "vm" {
  value = {
    name = google_compute_instance.instance.name
    ip   = google_compute_instance.instance.network_interface[0].network_ip
  }
}
