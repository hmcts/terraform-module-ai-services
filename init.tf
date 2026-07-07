terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 3.113.0"
      configuration_aliases = [azurerm.private_dns]
    }
  }
}
