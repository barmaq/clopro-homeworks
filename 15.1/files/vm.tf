# доп переменные


variable "nat_vm_name" {
  type        = string
  default     = "nat-vm"
  description = "name for VM in YC"
}

variable "public_vm_name" {
  type        = string
  default     = "public-vm"
  description = "name for VM in YC"
}

variable "private_vm_name" {
  type        = string
  default     = "private-vm"
  description = "name for VM in YC"
}

variable "nat_instance_ip" {
  description = "NAT local IP"
  type        = string
  default     = "192.168.10.254"
}
