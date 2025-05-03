
resource "yandex_iam_service_account" "ha-k8s-account" {
  # сервис аккаунт и права для него
  name        = "ha-k8s-account"
  description = "Service account for the highly available Kubernetes cluster"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  # в идеале вместо editor добавлять роли "kms.keys.encrypterDecrypter", "k8s.clusters.agent", "vpc.publicAdmin", "container-registry.images.puller", "kms.keys.encrypterDecrypter", 
  # Сервисному аккаунту назначается роль "editor".
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.ha-k8s-account.id}"
}


resource "yandex_kms_symmetric_key" "kms-key" {
  # Ключ Yandex Key Management Service для шифрования важной информации, такой как пароли, OAuth-токены и SSH-ключи.
  name              = "kms-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
}



#########


# кластер k8s
resource "yandex_kubernetes_cluster" "k8s-ha-three-zones" {
  name = var.k8s_master_name
  network_id = yandex_vpc_network.vpc.id
  master {
    master_location {
      zone      = yandex_vpc_subnet.public_zone_a.zone
      subnet_id = yandex_vpc_subnet.public_zone_a.id
    }
    master_location {
      zone      = yandex_vpc_subnet.public_zone_b.zone
      subnet_id = yandex_vpc_subnet.public_zone_b.id
    }
    master_location {
      zone      = yandex_vpc_subnet.public_zone_d.zone
      subnet_id = yandex_vpc_subnet.public_zone_d.id
    }
 #   тут  я не использую SG
 #   security_group_ids = [yandex_vpc_security_group.ha-k8s-sg.id]
 
# создаем публичный  endpoint. 
  version   = "1.29"
  public_ip = true

  }
  service_account_id      = yandex_iam_service_account.ha-k8s-account.id
  node_service_account_id = yandex_iam_service_account.ha-k8s-account.id
  depends_on = [
    yandex_resourcemanager_folder_iam_member.editor
  ]
  kms_provider {
    key_id = yandex_kms_symmetric_key.kms-key.id
  }

}

# # группы нодов k8s


resource "yandex_kubernetes_node_group" "k8s-node-groups" {
  for_each   = var.node_groups

  cluster_id = yandex_kubernetes_cluster.k8s-ha-three-zones.id
  name       = each.key
  version    = each.value.version
  labels     = each.value.labels

  instance_template {
    platform_id = each.value.platform_id

    network_interface {
      nat        = each.value.nat
      # все создаем в одной зоне
      subnet_ids = ["${yandex_vpc_subnet.public_zone_a.id}"]
    }

    resources {
      memory = each.value.memory
      cores  = each.value.cores
    }

    boot_disk {
      type = each.value.disk_type
      size = each.value.disk_size
    }

    scheduling_policy {
      preemptible = each.value.preemptible
    }

    container_runtime {
      type = each.value.runtime_type
    }

    metadata = {
      ssh-keys = "${each.value.ssh_user}:${var.metadata.standart.ssh-keys}"
    }
  }

  scale_policy {
    auto_scale {
      initial = each.value.initial_nodes
      min     = each.value.min_nodes
      max     = each.value.max_nodes
    }
  }

  allocation_policy {
    dynamic "location" {
      for_each = each.value.zones
      content {
        zone = location.value
      }
    }
  }
}


# resource "yandex_kubernetes_node_group" "k8s-node-group-a" {
#   cluster_id  = yandex_kubernetes_cluster.k8s-ha-three-zones.id
#   name        = "k8s-worker-group-a"

#   version     = "1.31"

#   labels = {
#     "key" = "k8s-worker-group-a"
#   }

#   instance_template {
#     platform_id = "standard-v2"

#     network_interface {
#       nat        = true
#       subnet_ids = ["${yandex_vpc_subnet.public_zone_a.id}"]
#        }
#     resources {
#       memory = 2
#       cores  = 2
#     }
#     boot_disk {
#       type = "network-hdd"
#       size = 64
#     }
#     scheduling_policy {
#       preemptible = true
#     }
#     container_runtime {
#       type = "containerd"
#     }
#       metadata = {
#         ssh-keys           = "ubuntu:${var.metadata.standart.ssh-keys}"
#     }
#   }
#   scale_policy {
#     auto_scale {
#       initial = 3
#       min = 3
#       max = 6
#     }
#   }
#   allocation_policy {
#     location {
#       zone = "ru-central1-a"
#     }   
#   }
# }