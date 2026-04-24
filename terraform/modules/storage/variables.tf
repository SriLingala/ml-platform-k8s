variable "storage_account_name" {
  type        = string
  description = "Globally unique storage account name"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "ml_workload_identity_principal_id" {
  type        = string
  description = "Principal ID of the AKS Workload Identity managed identity used by ML workloads"
}

variable "tags" {
  type    = map(string)
  default = {}
}
