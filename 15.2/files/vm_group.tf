# переработан пример из справки yandex_compute_instance_group

# resource "yandex_iam_service_account" "terraform" {
#   name        = "terraform-2"
#   description = "Сервисный аккаунт для управления группой ВМ."
# }

# resource "yandex_resourcemanager_folder_iam_member" "vpc_user" {
#   folder_id = var.folder_id
#   role      = "editor"
#   member    = "serviceAccount:${yandex_iam_service_account.terraform.id}"
# }


# resource "yandex_resourcemanager_folder_iam_member" "compute-editor" {
#   folder_id = "<идентификатор_каталога>"
#   role      = "compute.editor"
#   member    = "serviceAccount:${yandex_iam_service_account.terraform.id}"
# }



resource "yandex_resourcemanager_folder_iam_member" "load-balancer-editor" {
  folder_id = var.folder_id
  role      = "load-balancer.editor"
  member    = "serviceAccount:${yandex_iam_service_account.bucket_admin.id}"
}

resource "yandex_compute_instance_group" "ig-1" {
  name                = "fixed-ig-with-balancer"
  folder_id           = var.folder_id
  service_account_id  = "${yandex_iam_service_account.bucket_admin.id}"
  deletion_protection = false
  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }

    network_interface {
      network_id         = "${yandex_vpc_network.vpc.id}"
      subnet_ids         = ["${yandex_vpc_subnet.public.id}"]
    #  security_group_ids = ["<список_идентификаторов_групп_безопасности>"]
    }

    metadata = {
      ssh-keys = "barmaq:${var.metadata.standart.ssh-keys}"
      user-data  = "#cloud-config\n runcmd:\n - cd /var/www/html\n - echo '<html><img src=\"http://${yandex_storage_bucket.bucket_net.bucket_domain_name}/${yandex_storage_object.image.key}\"/></html>' | sudo tee index.html\n - sudo systemctl restart apache2"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "Целевая группа Network Load Balancer"
  }
}

resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "network-load-balancer-1"

  listener {
    name = "network-load-balancer-1-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.ig-1.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}

# resource "yandex_vpc_network" "network-1" {
#   name = "network1"
# }

# resource "yandex_vpc_subnet" "subnet-1" {
#   name           = "subnet1"
#   zone           = "ru-central1-a"
#   network_id     = "${yandex_vpc_network.network-1.id}"
#   v4_cidr_blocks = ["192.168.10.0/24"]
# }
