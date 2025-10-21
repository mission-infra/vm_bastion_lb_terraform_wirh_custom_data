variable "nic_id" {
  description = "The ID of the network interface"
  type        = string
  
}

variable "nic_ip_config_name" {
  description = "The name of the NIC IP configuration"
  type        = string

}

variable "backend_pool_id" {
  description = "The ID of the backend address pool"
  type        = string

}