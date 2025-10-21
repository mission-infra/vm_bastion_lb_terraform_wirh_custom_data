resource "azurerm_network_interface" "my_nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = var.nic_ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# output "nic_id" {
#   value = azurerm_network_interface.my_nic.id
# }

# output "nic_ip_config_name" {
#   description = "The name of the NIC's IP configuration"
#   value       = azurerm_network_interface.my_nic.ip_configuration[0].name
# }