module "vm" {
  source = "../../modules/vm"


  resource_group_name = var.resource_group
  location            = var.location

  vnet      = var.vnet
  subnet    = var.subnet
  public_ip = var.public_ip
  nsg       = var.nsg
  nic       = var.nic
  sku = var.sku
  storage_account_type = var.storage_account_type

  vm_name = var.vm_name
  vm_size = var.vm_size

  admin_username      = var.admin_username
  public_key = file(".ssh/id_rsa.pub")

}

module "aks" {
  source = "../../modules/aks"


  resource_group_name = var.resource_group

  law_name     = var.law_name
  amw_name     = var.amw_name
  grafana_name = var.grafana_name
  acr_name     = var.acr_name
  aks_name     = var.aks_name
  dns_prefix   = var.dns_prefix

  kubernetes_version = var.kubernetes_version

  vm_size      = var.aks_vm_size
  zones        = ["1"]
  min_count    = 1
  max_count    = 2
  os_disk_size = var.os_disk_size

  image_cleaner_interval = 48
}


