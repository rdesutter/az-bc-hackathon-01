variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
  default     = "Sweden Central"
}

variable "resource_group_name_prefix" {
  type        = string
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
  default     = "hack-rg"
}

variable "storage_account_name_prefix" {
  type        = string
  description = "Prefix of the storage account name that's combined with a random ID so name is unique in your Azure subscription."
  default     = "sa"  
}