terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features{
    virtual_machine {
      # This ensures the OS disk is automatically deleted when the VM is destroyed
      delete_os_disk_on_deletion = true
    }
    resource_group {
       prevent_deletion_if_contains_resources = false
   }
  }
  subscription_id = "cf696e5b-8a38-4c82-bd9d-69335e386853"
}

