module "ai" {
  source = "../"

  providers = {
    azurerm.private_dns = azurerm.private_dns
  }

  env         = var.env
  product     = "example"
  project     = "sds"
  component   = "ai"
  common_tags = { environment = var.env }

  key_vault_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.KeyVault/vaults/example-kv"
  subnet_id                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/example-subnet"
  enable_managed_network   = true
  create_cognitive_account = true
}
