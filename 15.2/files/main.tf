
#Создать пустую VPC. 
resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}

## создаем подсети
resource "yandex_vpc_subnet" "public" {
  name           = var.subnet_public_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.public_cidr
}

# resource "yandex_vpc_subnet" "private" {
#   name           = var.subnet_private_name
#   zone           = var.default_zone
#   network_id     = yandex_vpc_network.vpc.id
#   v4_cidr_blocks = var.private_cidr
#   # добавляем таблицу маршрутизации
#   route_table_id = yandex_vpc_route_table.private_route_table.id
# }



# data "yandex_compute_image" "ubuntu" {
#   family = var.vm_web_image_family
# }

#  nat instance
# Создание ВМ NAT

# resource "yandex_compute_instance" "nat-instance" {
#   name        = local.nat_vm
#   platform_id = "standard-v3"
#   zone        = "ru-central1-a"

#   resources {
#     cores         = var.vms_resources.nat.cores
#     memory        = var.vms_resources.nat.memory
#     core_fraction = var.vms_resources.nat.core_fraction
#   }

#   boot_disk {
#     initialize_params {
#       image_id = "fd80mrhj8fl2oe87o4e1"
#     }
#   }

#   network_interface {
#     subnet_id          = yandex_vpc_subnet.public.id
#     ip_address = var.nat_instance_ip
# #    security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
#     nat                = true
#   }

#   metadata = {
#     serial-port-enable = var.metadata.standart.serial-port-enable
#     ssh-keys           = "ubuntu:${var.metadata.standart.ssh-keys}"
#   }
# }


#  вм в публичной сети. 
# resource "yandex_compute_instance" "public_vm" {
#   name        = local.public_vm
#   hostname    = var.public_vm_name
#   zone        = var.default_zone
#   platform_id = var.vm_platform_id
#   resources {
#     cores         = var.vms_resources.public.cores
#     memory        = var.vms_resources.public.memory
#     core_fraction = var.vms_resources.public.core_fraction
#   }
#   boot_disk {
#     initialize_params {
#       image_id = data.yandex_compute_image.ubuntu.image_id
#     }
#   }
#   scheduling_policy {
#     preemptible = var.vm_def_preemptible
#   }
#   network_interface {
#     subnet_id = yandex_vpc_subnet.public.id
#     nat       = var.vm_default_nat
#   }

#   metadata = {
#     serial-port-enable = var.metadata.standart.serial-port-enable
#     ssh-keys           = "ubuntu:${var.metadata.standart.ssh-keys}"
#   }

# }

#  вм в приватной сети. без nat интерфейс ( дефолтное значение nat = false )
# resource "yandex_compute_instance" "private_vm" {
#   name        = local.private_vm
#   hostname    = var.private_vm_name
#   zone        = var.default_zone
#   platform_id = var.vm_platform_id
#   resources {
#     cores         = var.vms_resources.private.cores
#     memory        = var.vms_resources.private.memory
#     core_fraction = var.vms_resources.private.core_fraction
#   }
#   boot_disk {
#     initialize_params {
#       image_id = data.yandex_compute_image.ubuntu.image_id
#     }
#   }
#   scheduling_policy {
#     preemptible = var.vm_def_preemptible
#   }
#   network_interface {
#     subnet_id = yandex_vpc_subnet.private.id
# #    nat       = var.vm_default_nat
#   }

#   metadata = {
#     serial-port-enable = var.metadata.standart.serial-port-enable
#     ssh-keys           = "ubuntu:${var.metadata.standart.ssh-keys}"
#   }

# }

# # таблица маршрутизации для private подсети
# resource "yandex_vpc_route_table" "private_route_table" {
#   name       = "private-route-table"
#   network_id = yandex_vpc_network.vpc.id

#   static_route {
#     destination_prefix = "0.0.0.0/0"
#     next_hop_address  = "192.168.10.254" # NAT-инстанс как следующий хоп
#   }
# }

