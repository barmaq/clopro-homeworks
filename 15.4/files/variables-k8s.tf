variable "k8s_master_name" {
  type        = string
  default     = "k8s-ha-three-zones"
  description = "master cluster name"
}


variable "node_groups" {
  description = "Configuration for Kubernetes node groups"
  type = map(object({
    version       = string
    platform_id   = string
    nat           = bool
    memory        = number
    cores         = number
    disk_type     = string
    disk_size     = number
    preemptible   = bool
    runtime_type  = string
    ssh_user      = string
    initial_nodes = number
    min_nodes     = number
    max_nodes     = number
    zones         = list(string)
    labels        = map(string)
  }))
  default = {
    "k8s-worker-group-a" = {
      version       = "1.29"
      platform_id   = "standard-v2"
      nat           = true
      memory        = 2
      cores         = 2
      disk_type     = "network-hdd"
      disk_size     = 64
      preemptible   = true
      runtime_type  = "containerd"
      ssh_user      = "ubuntu"
      initial_nodes = 3
      min_nodes     = 3
      max_nodes     = 6
      zones         = ["ru-central1-a"]
      labels        = { "key" = "k8s-worker-group-a" }
    }
  }
}