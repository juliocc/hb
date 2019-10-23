variable "disk_size" {
  type    = number
  default = 10
}

variable "image" {
  type    = string
  default = "debian-10"
}

variable "machine_type" {
  type    = string
  default = "n1-standard-1"
}

variable "names" {
  type = list
}
