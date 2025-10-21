module "rg" {
  source   = "../../module/01_azurerm_rg"
  rg_name  = "mybastion_rg"
  location = "japan east"
}

module "vnet" {
  depends_on    = [module.rg]
  source        = "../../module/02_azurerm_vnet"
  vnet_name     = "oppo-vnet"
  location      = "japan east"
  rg_name       = "mybastion_rg"
  address_space = ["10.0.0.0/16"]
}

module "vm_subnet" {
  depends_on       = [module.vnet]
  source           = "../../module/03_azurerm_subnet"
  subnet_name      = "vm-subnet"
  rg_name          = "mybastion_rg"
  vnet_name        = "oppo-vnet"
  address_prefixes = ["10.0.1.0/24"]
}

module "bastion_subnet" {
  depends_on       = [module.vnet]
  source           = "../../module/03_azurerm_subnet"
  subnet_name      = "AzureBastionSubnet"
  rg_name          = "mybastion_rg"
  vnet_name        = "oppo-vnet"
  address_prefixes = ["10.0.2.0/24"]
}

module "pip" {
  depends_on     = [module.rg]
  source         = "../../module/04_azurerm_public_ip"
  public_ip_name = "vivopip"
  location       = "japan east"
  rg_name        = "mybastion_rg"
}

module "frontend_vm" {
  depends_on                = [module.rg, module.vnet]
  source                    = "../../module/05_azurerm_vm"
  vm_name                   = "bastion-frontendvm"
  rg_name                   = "mybastion_rg"
  location                  = "japan east"
  vm_size                   = "Standard_B1s"
  admin_username            = data.azurerm_key_vault_secret.kv_usec.value
  admin_password            = data.azurerm_key_vault_secret.kv_psec.value
  nic_name                  = "mynokianicfront"
  subnet_id                 = data.azurerm_subnet.subvmdata.id
  nic_ip_configuration_name = "frontendvmnic"
}

module "backend_vm" {
  depends_on                = [module.rg, module.vnet]
  source                    = "../../module/05_azurerm_vm"
  vm_name                   = "bastion-backendvm"
  rg_name                   = "mybastion_rg"
  location                  = "japan east"
  vm_size                   = "Standard_B1s"
  admin_username            = data.azurerm_key_vault_secret.kv_usec.value
  admin_password            = data.azurerm_key_vault_secret.kv_psec.value
  nic_name                  = "mynokianicback"
  subnet_id                 = data.azurerm_subnet.subvmdata.id
  nic_ip_configuration_name = "backendvmnic"
}

module "bastion_host" {
  depends_on            = [module.pip]
  source                = "../../module/06_azurerm_bh"
  bastion_name          = "mybastionhost"
  rg_name               = "mybastion_rg"
  location              = "japan east"
  ip_configuration_name = "bst_ip"
  public_ip_address_id  = data.azurerm_public_ip.pipdata.id
  subnet_id             = data.azurerm_subnet.subdata.id
}

module "nsg" {
  depends_on = [module.vm_subnet]
  source     = "../../module/07_azurerm_nsg"
  rg_name    = "mybastion_rg"
  location   = "japan east"
  nsg_name   = "vm-nsg"
  subnet_id  = data.azurerm_subnet.subvmdata.id
}

module "lb" {
  depends_on                     = [module.rg,]
  source                         = "../../module/08_azurerm_lb"
  lb_name                        = "myloadbalancer"
  location                       = "japan east"
  resource_group_name            = "mybastion_rg"
  frontend_ip_configuration_name = "lb-frontend-ip"
  backend_address_pool_name      = "lb-backend-pool"
  lbrule_name                    = "http-rule"
  h_probe_name                   = "http-probe"
}


module "frontend_nic_lb_association" {
  depends_on = [ module.lb, module.frontend_vm ]
  source                = "../../module/09_nic_lb_association"
  nic_id                = data.azurerm_network_interface.nic-front.id
  nic_ip_config_name    = "frontendvmnic"
  backend_pool_id       = data.azurerm_lb_backend_address_pool.backend-pool.id
}
module "backend_nic_lb_association" {
  depends_on = [ module.lb, module.backend_vm ]
  source                = "../../module/09_nic_lb_association"
  nic_id                = data.azurerm_network_interface.nic-back.id
  nic_ip_config_name    = "backendvmnic"
  backend_pool_id       = data.azurerm_lb_backend_address_pool.backend-pool.id
}













