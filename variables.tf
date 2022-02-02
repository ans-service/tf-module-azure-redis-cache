variable "redis_instance_name" {
  type        = string
  description = "description"
}

variable "capacity" {
  type        = number
  default     = 1
  description = "Redis Disk Capacity (Giga Bytes)"
}

variable "family" {
  type        = string
  default     = "C"
  description = "Redis Family"
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "Redis SKU"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  default     = "East US 2"
  description = "Resource location"
}

variable "vnet_id" {
  type        = string
  description = "VNet ID"
}

variable "subnet_id" {
  type        = string
  description = "SubNet ID"
}

variable "tags" {
  type = map(any)
  default = {
    "Environment" = "develop"
  }
  description = "Resource Tags"
}
