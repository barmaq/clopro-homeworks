###cloud vars


variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
  default     = "b1g2678hn0b6tk45jj76"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
  default     = "b1gg0512n1fejb81t8f8"
}

#network
variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}


variable "default_cidr" {
  type        = list(string)
  default     = ["10.128.0.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "vpc"
  description = "VPC network name"
}

variable "subnet_public_name" {
  type        = string
  default     = "public"
  description = "subnet name"
}

# приватные подсети
# variable "subnet_private_a_name" {
#   type        = string
#   default     = "private-a"
#   description = "subnet name"
# }

# variable "subnet_private_b_name" {
#   type        = string
#   default     = "private-b"
#   description = "subnet name"
# }

# variable "public_cidr" {
#   type        = list(string)
#   default     = ["192.168.10.0/24"]
#   description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
# }

# variable "private_a_cidr" {
#   type        = list(string)
#   default     = ["192.168.20.0/24"]
#   description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
# }

# variable "private_b_cidr" {
#   type        = list(string)
#   default     = ["192.168.21.0/24"]
#   description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
# }

# variable "a_zone" {
#   type        = string
#   default     = "ru-central1-a"
#   description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
# }

# variable "b_zone" {
#   type        = string
#   default     = "ru-central1-b"
#   description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
# }

## приватные подсети в map
variable "private_subnets" {
  description = "map of private subnets configuration"
  type = map(object({
    name        = string
    cidr_blocks = list(string)
    zone        = string
  }))
  default = {
    "private-a" = {
      name        = "private-a"
      cidr_blocks = ["192.168.20.0/24"]
      zone        = "ru-central1-a"
    },
  "private-b" = {
      name        = "private-b"
      cidr_blocks = ["192.168.21.0/24"]
      zone        = "ru-central1-b"
    }
  }
}

# публичные подсети в map
variable "public_subnets" {
  description = "map of public subnets configuration"
  type = map(object({
    name        = string
    cidr_blocks = list(string)
    zone        = string
  }))
  default = {
    "public-a" = {
      name        = "public-a"
      cidr_blocks = ["192.168.10.0/24"]
      zone        = "ru-central1-a"
    },
    "public-b" = {
      name        = "public-b"
      cidr_blocks = ["192.168.11.0/24"]
      zone        = "ru-central1-b"
    },
    "public-d" = {
      name        = "public-d"
      cidr_blocks = ["192.168.12.0/24"]
      zone        = "ru-central1-d"
    }    
  }
}


###ssh vars

# variable "vms_ssh_root_key" {
#   type        = string
#   default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4DFQBsJA/Djtas+6WVht6qyVPLgia0JVBjEmNrnmdL barmaq for yacloud"
#   description = "ssh-keygen -t ed25519"
# }

# variable "vms_ssh_public_root_key" {
#   type        = string
#   default     = "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyMJezE+Yc+NjyJOkIi+a\nrjxm6+CSbry6Sb2zHiDNhAALX663UDuH1qVKiivvSDvalfn0yr2PZ7/YUkAI/14l\nJ0hC6ZaVulSX5dcU3l97e98BR6vzdT5w14JJwtnRDIwMzcVBytC8sxylqzHvHgLO\nMQsaXYMlxmuCoXNgANAYkwPb3lnE/JWMu+y44HBqUoP700oSxWjJKHWpiHM3nvFn\n1bofJYTyaZCbaWqgaxeITjHXIrspwOl9Bm27p89VbBKcYa6J96mB4T2mEGgSrARy\nBCLG4cpPUGgVLZ3qleRjrtaM62KiJmyuZFKQEqbUAxFvg/o1+y4IYVs7ewyrBLDo\nEwIDAQAB\n-----END PUBLIC KEY-----\n"
#   description = "ssh-key RSA_2048"
# }

variable "metadata" {
  type = map(object({
    serial-port-enable         = number
    ssh-keys                   = string
  }))
  default = {
    "standart" = {
		serial-port-enable         = 1
		ssh-keys                   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4DFQBsJA/Djtas+6WVht6qyVPLgia0JVBjEmNrnmdL barmaq for yacloud"
    }
  }
}

