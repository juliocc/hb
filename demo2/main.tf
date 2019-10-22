module "vm1" {
  source = "./modules/vm"
  name   = "testvm1"
}

module "vm2" {
  source       = "./modules/vm"
  name         = "testvm2"
  machine_type = "n1-standard-4"
}

module "vm3" {
  source    = "./modules/vm"
  name      = "testvm3"
  disk_size = 25
  image     = "debian-9"
}
