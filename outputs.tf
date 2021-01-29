output "app_service_name" {
  value = azurerm_app_service.example.name
}

output "app_service_default_hostname" {
  value = "https://${azurerm_app_service.example.default_site_hostname}"
}

output "app_url" {
  value = format("%s%s","http://", azurerm_app_service.example.default_site_hostname)
  
}
