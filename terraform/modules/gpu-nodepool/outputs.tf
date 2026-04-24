output "training_node_pool_id" {
  value       = azurerm_kubernetes_cluster_node_pool.gpu_training.id
  description = "Resource ID of the GPU training node pool"
}

output "inference_node_pool_id" {
  value       = azurerm_kubernetes_cluster_node_pool.gpu_inference.id
  description = "Resource ID of the GPU inference node pool"
}
