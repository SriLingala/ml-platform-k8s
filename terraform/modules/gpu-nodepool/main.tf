resource "azurerm_kubernetes_cluster_node_pool" "gpu_training" {
  name                  = "gputrain"
  kubernetes_cluster_id = var.cluster_id
  vm_size               = var.training_vm_size   # e.g. Standard_NC6s_v3 (V100)
  node_count            = 0
  min_count             = 0
  max_count             = var.training_max_nodes
  enable_auto_scaling   = true
  priority              = "Spot"
  eviction_policy       = "Delete"
  spot_max_price        = -1 # pay up to on-demand price

  node_labels = {
    "workload-type"                     = "ml-training"
    "nvidia.com/gpu"                    = "true"
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }

  node_taints = [
    "sku=gpu:NoSchedule",
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
  ]

  os_disk_size_gb = 128
  os_disk_type    = "Ephemeral"

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "gpu_inference" {
  name                  = "gpuinfer"
  kubernetes_cluster_id = var.cluster_id
  vm_size               = var.inference_vm_size  # e.g. Standard_NC4as_T4_v3 (T4)
  node_count            = 1
  min_count             = 1
  max_count             = var.inference_max_nodes
  enable_auto_scaling   = true
  priority              = "Regular"             # on-demand — SLA matters for serving

  node_labels = {
    "workload-type"  = "ml-serving"
    "nvidia.com/gpu" = "true"
  }

  node_taints = [
    "sku=gpu:NoSchedule"
  ]

  os_disk_size_gb = 64
  os_disk_type    = "Ephemeral"

  tags = var.tags
}
