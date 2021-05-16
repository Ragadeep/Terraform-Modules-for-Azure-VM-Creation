terraform {
  backend "azurerm" {
    resource_group_name  = "backend"
    storage_account_name = "remotestate123"
    container_name       = "terraformstate"
    key                  = "dev.terraform.terraformstate"
  }
}