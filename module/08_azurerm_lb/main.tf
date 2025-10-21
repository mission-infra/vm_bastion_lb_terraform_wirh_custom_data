resource "azurerm_public_ip" "lb-public-ip" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "mylb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.lb-public-ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend-pool" {
  loadbalancer_id = azurerm_lb.mylb.id
  name            = var.backend_address_pool_name
}


resource "azurerm_lb_rule" "lb-rule" {
  loadbalancer_id                = azurerm_lb.mylb.id
  name                           = var.lbrule_name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
  backend_address_pool_ids = [  azurerm_lb_backend_address_pool.backend-pool.id ]
  probe_id = azurerm_lb_probe.h-probe.id
}

resource "azurerm_lb_probe" "h-probe" {
  loadbalancer_id     = azurerm_lb.mylb.id
  name                = var.h_probe_name
  port                = 80
  protocol            = "Tcp"
}


# output "backend_pool_id" {
#   value = azurerm_lb_backend_address_pool.backend-pool.id
  
# }

# output "lb-id" {
#   value = azurerm_lb.mi-lb.id
# }