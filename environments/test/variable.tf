variable "name" {
  default = "aks_demo_cluster001"
}

variable "location" {
  default = "central india"
}

variable "resource_group" {
  default = "sample-rg-demo"
}

variable "law_name" {}
variable "amw_name" {}
variable "grafana_name" {}
variable "aks_name" {}
variable "acr_name" {}
variable "dns_prefix" {}
variable "kubernetes_version" {}
variable "aks_vm_size" {}
variable "os_disk_size" {}

#### VM variables #######
variable "vnet" {}
variable "subnet" {}
variable "public_ip" {}
variable "nsg" {}
variable "vm_name" {}
variable "vm_size" {}
variable "admin_username" {}
variable "storage_account_type" {}
variable "sku" {}
variable "nic" {}

# variable "public_key" {
#   type = string
#   sensitive = true
# }