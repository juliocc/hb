resource "google_compute_instance" "instance" {
  for_each     = toset(var.names)
  name         = each.value
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}
