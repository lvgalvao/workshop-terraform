output "sql_server_address" {
  value = azurerm_mssql_server.example.fully_qualified_domain_name
}

output "sql_database_name" {
  value = azurerm_mssql_database.example.name
}

output "vm_public_ip" {
  value = azurerm_public_ip.example.ip_address
}
