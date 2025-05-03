variable "mysql_cluster" {
  type = object({
    name                   = string
    environment            = string
    version                = string
    resources              = object({
      resource_preset_id = string
      disk_type_id       = string
      disk_size          = number
    })
    maintenance_window_type = string
    backup_window_start     = object({
      hours   = number
      minutes = number
    })
    deletion_protection = bool
  })

  default = {
    name        = "test"
    environment = "PRESTABLE"
    version     = "8.0"

    resources = {

    #   resource_preset_id = "s2.micro"
    #   disk_type_id       = "network-ssd"
    #   disk_size          = 16
      resource_preset_id = "b1.medium"
      disk_type_id       = "network-hdd"
      disk_size          = 20
    }

    maintenance_window_type = "ANYTIME"

    backup_window_start = {
      hours   = 22
      minutes = 0
    }

    deletion_protection = true
  }
}

variable "mysql_hosts" {
  type = map(object({
    name             = string
    zone             = string
  }))

  default = {
    "host-a" = {
      name             = "mysql-a"
      zone             = "ru-central1-a"
    }
    "host-b" = {
      name             = "mysql-b"
      zone             = "ru-central1-b"
    }
  }
}

variable "database" {
  type = object({
    name = string
  })

  default = {
    name = "netology_db"
  }
}

variable "user" {
  type = object({
    name               = string
    password           = string
    roles              = list(string)
    global_permissions = list(string)
  })

  default = {
    name               = "dbuser"
    password           = "IXkmp3DWa9"
    roles              = ["ALL"]
    global_permissions = ["PROCESS"]
  }
}
