variable "cluster_id" {
  type        = string
  description = "AKS cluster resource ID"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "ml_workload_identity_principal_id" {
  type = string
}

variable "kubelet_identity_principal_id" {
  type = string
}

variable "ml_pipeline_identity_principal_id" {
  type = string
}
