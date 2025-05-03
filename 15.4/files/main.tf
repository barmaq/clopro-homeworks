
#Создать пустую VPC. 
resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}

## создаем подсети
# публичные
resource "yandex_vpc_subnet" "public_zone_a" {
  name           = var.public_subnets.public-a.name
  zone           = var.public_subnets.public-a.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.public_subnets.public-a.cidr_blocks
}

resource "yandex_vpc_subnet" "public_zone_b" {
  name           = var.public_subnets.public-b.name
  zone           = var.public_subnets.public-b.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.public_subnets.public-b.cidr_blocks
}

resource "yandex_vpc_subnet" "public_zone_d" {
  name           = var.public_subnets.public-d.name
  zone           = var.public_subnets.public-d.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.public_subnets.public-d.cidr_blocks
}



# приватные
resource "yandex_vpc_subnet" "private_zone_a" {
  name           = var.private_subnets.private-a.name
  zone           = var.private_subnets.private-a.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.private_subnets.private-a.cidr_blocks
}

resource "yandex_vpc_subnet" "private_zone_b" {
  name           = var.private_subnets.private-b.name
  zone           = var.private_subnets.private-b.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = var.private_subnets.private-b.cidr_blocks
}



