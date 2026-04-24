output "defender_extension_id" {
  value       = var.enable_defender ? azurerm_kubernetes_cluster_extension.defender[0].id : null
  description = "Resource ID of the Defender for Containers cluster extension"
}
