variable "lb_name" {
  description = "The name of the Load Balancer"
  type        = string
}

variable "location" {
  description = "The location where the resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "frontend_ip_configuration_name" {
  description = "The name of the frontend IP configuration"
  type        = string
}

# variable "public_ip_id" {
#   description = "The ID of the public IP address"
#   type        = string
# }

variable "backend_address_pool_name" {
  description = "The name of the backend address pool"
  type        = string
}

variable "lbrule_name" {
  description = "The name of the load balancer rule"
  type        = string  
}

variable "h_probe_name" {
  description = "The name of the health probe"
  type        = string

}
