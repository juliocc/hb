/**
 * Copyright 2017 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

data "template_file" "group1-startup-script" {
  template = file(format("%s/gceme.sh.tpl", path.module))

  vars = {
    PROXY_PATH = "/group1"
  }
}

data "template_file" "group2-startup-script" {
  template = file(format("%s/gceme.sh.tpl", path.module))

  vars = {
    PROXY_PATH = "/group2"
  }
}

data "template_file" "group3-startup-script" {
  template = file(format("%s/gceme.sh.tpl", path.module))

  vars = {
    PROXY_PATH = "/group3"
  }
}

locals {
  update_policy = [{
    type                         = "PROACTIVE"
    instance_redistribution_type = "PROACTIVE"
    minimal_action               = "REPLACE"
    max_surge_fixed              = 4
    max_surge_percent            = null
    max_unavailable_fixed        = 4
    max_unavailable_percent      = null
    min_ready_sec                = 10
  }]
  target_size   = 6
  image         = "ubuntu-1804-lts"
  image_project = "ubuntu-os-cloud"
}

module "mig1_template" {
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  version              = "1.1.1"
  network              = google_compute_network.default.self_link
  subnetwork           = google_compute_subnetwork.group1.self_link
  service_account      = var.service_account
  name_prefix          = "${var.network_name}-group1"
  startup_script       = data.template_file.group1-startup-script.rendered
  source_image_family  = local.image
  source_image_project = local.image_project
  tags = [
    "${var.network_name}-group1",
    module.cloud-nat-group1.router_name
  ]
}

module "mig1" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "1.1.1"
  instance_template = module.mig1_template.self_link
  region            = var.group1_region
  hostname          = "${var.network_name}-group1"
  target_size       = local.target_size
  named_ports = [{
    name = "http",
    port = 80
  }]
  update_policy           = local.update_policy
  hc_initial_delay_sec    = 5
  hc_port                 = 80
  http_healthcheck_enable = true
  network                 = google_compute_network.default.self_link
  subnetwork              = google_compute_subnetwork.group1.self_link
}

module "mig2_template" {
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  version              = "1.1.1"
  network              = google_compute_network.default.self_link
  subnetwork           = google_compute_subnetwork.group2.self_link
  service_account      = var.service_account
  name_prefix          = "${var.network_name}-group2"
  startup_script       = data.template_file.group2-startup-script.rendered
  source_image_family  = local.image
  source_image_project = local.image_project
  tags = [
    "${var.network_name}-group2",
    module.cloud-nat-group2.router_name
  ]
}

module "mig2" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "1.1.1"
  instance_template = module.mig2_template.self_link
  region            = var.group2_region
  hostname          = "${var.network_name}-group2"
  target_size       = local.target_size
  named_ports = [{
    name = "http",
    port = 80
  }]
  update_policy           = local.update_policy
  hc_initial_delay_sec    = 5
  hc_port                 = 80
  http_healthcheck_enable = true
  network                 = google_compute_network.default.self_link
  subnetwork              = google_compute_subnetwork.group2.self_link
}


module "mig3_template" {
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  version              = "1.1.1"
  network              = google_compute_network.default.self_link
  subnetwork           = google_compute_subnetwork.group3.self_link
  service_account      = var.service_account
  name_prefix          = "${var.network_name}-group3"
  startup_script       = data.template_file.group3-startup-script.rendered
  source_image_family  = local.image
  source_image_project = local.image_project
  tags = [
    "${var.network_name}-group3",
    module.cloud-nat-group2.router_name
  ]
}

module "mig3" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "1.1.1"
  instance_template = module.mig3_template.self_link
  region            = var.group3_region
  hostname          = "${var.network_name}-group3"
  target_size       = local.target_size
  named_ports = [{
    name = "http",
    port = 80
  }]
  update_policy           = local.update_policy
  hc_initial_delay_sec    = 5
  hc_port                 = 80
  http_healthcheck_enable = true
  network                 = google_compute_network.default.self_link
  subnetwork              = google_compute_subnetwork.group3.self_link
}
