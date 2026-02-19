provider "azurerm" {
  features {}
}

locals {
  # Storage Account names must be 3-24 chars, lowercase letters/digits only.
  # Optional suffix can be used if global name collisions occur.
  # Example: st<appname>staging<suffix>
  staging_path = "${var.app_name}-staging"

  sites = {
    prod = {
      sa_name = join("", compact(["st", var.app_name, "prod", var.name_suffix]))
      tags    = merge(var.tags, { env = "prod" })
    }
    staging = {
      sa_name = join("", compact(["st", var.app_name, "staging", var.name_suffix]))
      tags    = merge(var.tags, { env = "staging" })
    }
  }
}

resource "azurerm_resource_group" "rg" {
  for_each = local.sites

  name     = "rg-${var.app_name}-${each.key}"
  location = var.location

  tags = each.value.tags
}

resource "azurerm_storage_account" "site" {
  for_each                 = local.sites
  name                     = each.value.sa_name
  resource_group_name      = azurerm_resource_group.rg[each.key].name
  location                 = azurerm_resource_group.rg[each.key].location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # This challenge requires a public static website URL; allow public access.
  allow_nested_items_to_be_public = true

  tags = each.value.tags
}

# Configure Static Website using the dedicated resource (per official provider docs).
resource "azurerm_storage_account_static_website" "site" {
  for_each           = azurerm_storage_account.site
  storage_account_id = each.value.id
  index_document     = "index.html"
  error_404_document = "404.html"
}
