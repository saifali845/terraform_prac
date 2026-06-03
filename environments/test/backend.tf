terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"              # RG holding storage account
    storage_account_name = "tfstate26868239535"      # Must be globally unique
    container_name       = "tfstate"
    key                  = "test.terraform.tfstate" # State file name
  }
}

