output "production_storage_account_name" {
  description = "Storage Account name for production site."
  value       = azurerm_storage_account.site["prod"].name
}

output "staging_storage_account_name" {
  description = "Storage Account name for staging site."
  value       = azurerm_storage_account.site["staging"].name
}

output "production_site_url" {
  description = "Production static website endpoint (contains superspecials in hostname)."
  value       = azurerm_storage_account.site["prod"].primary_web_endpoint
}

output "staging_site_url" {
  description = "Staging URL includes superspecials-staging in the path."
  value       = "${azurerm_storage_account.site["staging"].primary_web_endpoint}${local.staging_path}/"
}
