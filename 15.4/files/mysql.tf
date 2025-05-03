##
# # поднимаем mysql кластер
resource "yandex_mdb_mysql_cluster" "netology_mysql_cluster" {
  name        = var.mysql_cluster.name
  environment = var.mysql_cluster.environment
  network_id  = yandex_vpc_network.vpc.id
  version     = var.mysql_cluster.version

  resources {
    resource_preset_id = var.mysql_cluster.resources.resource_preset_id
    disk_type_id       = var.mysql_cluster.resources.disk_type_id
    disk_size          = var.mysql_cluster.resources.disk_size
  }

# окно техобслуживания - по умолчанию в любое время
  # maintenance_window {
  #   type = var.mysql_cluster.maintenance_window_type
  # }

  backup_window_start {
    hours   = var.mysql_cluster.backup_window_start.hours
    minutes = var.mysql_cluster.backup_window_start.minutes
  }

# создаем хосты в разных зонах
    host {
    name = var.mysql_hosts.host-a.name
    zone      = var.mysql_hosts.host-a.zone
    subnet_id = yandex_vpc_subnet.private_zone_a.id
  }

    host {
    name = var.mysql_hosts.host-b.name
    zone      = var.mysql_hosts.host-b.zone
    subnet_id = yandex_vpc_subnet.private_zone_b.id
  }

# защита от удаления. закомментирована для корректного удаления ресурсов
#  deletion_protection = var.mysql_cluster.deletion_protection
}

# создаем базу данных
resource "yandex_mdb_mysql_database" "netology_mysql" {
  cluster_id = yandex_mdb_mysql_cluster.netology_mysql_cluster.id
  name       = var.database.name
}

# # создаем пользователя и права
resource "yandex_mdb_mysql_user" "dbuser" {
  cluster_id = yandex_mdb_mysql_cluster.netology_mysql_cluster.id
  name       = var.user.name
  password   = var.user.password

  permission {
    database_name = var.database.name
    roles         = var.user.roles
  }

  global_permissions = var.user.global_permissions

    depends_on = [
    yandex_mdb_mysql_database.netology_mysql
  ]
}