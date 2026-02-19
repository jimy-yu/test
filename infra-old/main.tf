provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  # Single RG keeps the challenge minimal; production would likely split per env.
  name     = "rg-${var.app_name}-${var.name_suffix}"
  location = var.location

  tags = merge(var.tags, { env = "shared" })
}

locals {
  # Storage Account names must be 3-24 chars, lowercase letters/digits only.
  # "superspecialsstaging" is 20 chars, so name_suffix is limited to 4 chars.
  staging_path = "${var.app_name}-staging"

  sites = {
    prod = {
      sa_name = "${var.app_name}${var.name_suffix}"
      tags    = merge(var.tags, { env = "prod" })
    }
    staging = {
      sa_name = "${var.app_name}staging${var.name_suffix}"
      tags    = merge(var.tags, { env = "staging" })
    }
  }
}

resource "azurerm_storage_account" "site" {
  for_each                 = local.sites
  name                     = each.value.sa_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # This challenge requires a public static website URL; allow public access.
  allow_nested_items_to_be_public = true

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }

  tags = each.value.tags
}
