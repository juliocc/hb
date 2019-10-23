module "web" {
  source = "./modules/vm"
  names  = ["web-1", "web-2", "web-3"]
}

module "backend" {
  source = "./modules/vm"
  names  = [for x in range(10) : "backend-${x}"]
}

output "vms" {
  value = {
    web     = { for id, vm in module.web.vms : vm.name => vm.network_interface[0].network_ip }
    backend = { for id, vm in module.backend.vms : vm.name => vm.network_interface[0].network_ip }
  }

}
