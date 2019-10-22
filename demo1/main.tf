resource "google_compute_instance" "instance" {
  name         = "my-first-vm"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "debian-10"
      size  = var.disk_size
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}
