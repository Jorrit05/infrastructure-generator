provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.72.0"
    }
  }
  backend "azurerm" {
    key = "terraform.tfstate"
    use_oidc = true
  }
}

provider "azurerm" {
  use_oidc = true
  skip_provider_registration = true
  features {}
}

data "azurerm_client_config" "current" {}


resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}-test-${var.env}"
  location = var.location
}
