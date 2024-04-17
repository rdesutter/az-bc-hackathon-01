data "azurerm_client_config" "current" {}

# Generate random resource group name
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "random_string" "resource_sa" {
  length  = 20
  special = false
  upper   = false
}

resource "azurerm_storage_account" "storage_account" {
  name = "${var.storage_account_name_prefix}${random_string.resource_sa.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"  
}

resource "azurerm_storage_container" "product-images" {
  name = "images"
  storage_account_name = azurerm_storage_account.storage_account.name
  container_access_type = "blob"
}


resource "azurerm_storage_blob" "files" {
  for_each = { for file in fileset("${path.module}/img", "*") : file => file }

  name                   = each.key
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.product-images.name
  type                   = "Block"
  source                 = "${path.module}/img/${each.key}"
}
