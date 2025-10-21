data "azurerm_key_vault" "my_kv" {
  name                = "tijori"
  resource_group_name = "bappa-remotestate-rg"
}

data "azurerm_key_vault_secret" "kv_usec" {
  name         = "tijoriname"
  key_vault_id = data.azurerm_key_vault.my_kv.id
}
data "azurerm_key_vault_secret" "kv_psec" {
  name         = "tijoripassword"
  key_vault_id = data.azurerm_key_vault.my_kv.id
}

data "azurerm_public_ip" "pipdata" {
  depends_on = [ module.pip ]
  name                = "empirepip"
  resource_group_name = "empirelb-rg"
}

output "public_ip_address" {
  value = data.azurerm_public_ip.pipdata.id
}

data "azurerm_subnet" "subdata" {
  depends_on = [ module.bastion_subnet ]
  name                 = "AzureBastionSubnet"
  virtual_network_name = "empire-vnet"
  resource_group_name  = "empirelb-rg"
}

output "subnet_id" {
  value = data.azurerm_subnet.subdata.id
}

data "azurerm_subnet" "subvmdata" {
  depends_on = [ module.vm_subnet ]
  name                 = "empire-subnet"
  virtual_network_name = "empire-vnet"
  resource_group_name  = "empirelb-rg"
}


data "azurerm_lb_backend_address_pool" "backend-pool" {
  name            = "lb-backend-pool"
  loadbalancer_id = data.azurerm_lb.loadbalancer.id
}

data "azurerm_lb" "loadbalancer" {
  depends_on = [ module.lb ]
  name                = "myloadbalancer"
  resource_group_name = "mybastion_rg"
}

data "azurerm_network_interface" "nic-front" {
  depends_on = [ module.frontend_vm ]
  name                = "empirenicfront"
  resource_group_name = "empirelb-rg"

}

data "azurerm_network_interface" "nic-back" {
  depends_on = [ module.backend_vm ]
  name                = "empirenicback"
  resource_group_name = "empirelb-rg"

}