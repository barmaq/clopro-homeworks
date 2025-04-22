locals {
 nat_vm = "netology-${ var.default_zone }-${ var.nat_vm_name }"
 public_vm = "netology-${ var.default_zone }-${ var.public_vm_name }"
 private_vm = "netology-${ var.default_zone }-${ var.private_vm_name }"
}