terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.94.0"
    }
  }
}

provider "azurerm" {
  features {}
  # Configuration options
  subscription_id = var.subscription_id
  #client_id       = var.client_id
  #client_secret   = var.client_secret
  tenant_id       = var.tenant_id

}

data "azurerm_client_config" "current" {}