provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "private_dns"
  subscription_id = "1baf5470-1c3e-40d3-a6f7-74bfbce4b348" # DTS-CFTPTL-INTSVC
  features {}
}
