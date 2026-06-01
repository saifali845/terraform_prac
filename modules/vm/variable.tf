variable "resource_group_name" {
  default = "sample-rg-demo"
}

variable "location" {
  default = "central india"
}

variable "vnet"{}
variable "subnet"{}
variable "public_ip"{}
variable "nsg"{}
variable "vm_name"{}
variable "vm_size"{}
variable "admin_username"{}
variable "storage_account_type"{}
variable "sku"{}
variable "nic"{}


variable "public_key" {
  type = string
  sensitive = true
}