terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "stmlplatformtfdev"
    container_name       = "tfstate"
    key                  = "ml-platform/dev/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "gpu_nodepool" {
  source = "../../modules/gpu-nodepool"

  cluster_id          = var.cluster_id
  training_vm_size    = "Standard_NC6s_v3"
  inference_vm_size   = "Standard_NC4as_T4_v3"
  training_max_nodes  = 2    # smaller cap in dev
  inference_max_nodes = 1

  tags = local.tags
}

module "storage" {
  source = "../../modules/storage"

  storage_account_name              = "stmlplatformdev"
  resource_group_name               = var.resource_group_name
  location                          = var.location
  ml_workload_identity_principal_id = var.ml_workload_identity_principal_id

  tags = local.tags
}

module "acr" {
  source = "../../modules/acr"

  acr_name                           = "acrmlplatformdev"
  resource_group_name                = var.resource_group_name
  location                           = var.location
  kubelet_identity_principal_id      = var.kubelet_identity_principal_id
  ml_pipeline_identity_principal_id  = var.ml_pipeline_identity_principal_id

  tags = local.tags
}

module "defender" {
  source = "../../modules/defender"

  cluster_id                 = var.cluster_id
  enable_defender            = false   # set true in prod
  log_analytics_workspace_id = ""
}

locals {
  tags = {
    environment = "dev"
    project     = "ml-platform"
    managed-by  = "terraform"
  }
}
