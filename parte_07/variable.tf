# variables.tf

variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
  default     = "myResourceGroup"
}

variable "location" {
  description = "Localização do Resource Group"
  type        = string
  default     = "Brazil South"
}

variable "sql_server_name" {
  description = "Nome do servidor SQL"
  type        = string
}

variable "admin_username" {
  description = "Nome de usuário do administrador"
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "Senha do administrador"
  type        = string
}

variable "public_ip_allocation_method" {
  description = "Método de alocação do IP público"
  type        = string
  default     = "Static"
}

variable "vm_size" {
  description = "Tamanho da máquina virtual"
  type        = string
  default     = "Standard_F2"
}
