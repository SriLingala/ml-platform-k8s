resource "azurerm_container_registry" "ml" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"  # Premium needed for private endpoint + geo-replication
  admin_enabled       = false      # Use Workload Identity, not admin credentials

  # Quarantine policy — scan images before they're pullable
  quarantine_policy_enabled = true

  # Retention policy — clean up untagged manifests
  retention_policy {
    days    = 30
    enabled = true
  }

  network_rule_set {
    default_action = "Deny"
  }

  tags = var.tags
}

# Grant AKS kubelet identity pull access
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.ml.id
  role_definition_name = "AcrPull"
  principal_id         = var.kubelet_identity_principal_id
}

# Grant ML pipelines push access (for pushing trained model containers)
resource "azurerm_role_assignment" "ml_pipeline_push" {
  scope                = azurerm_container_registry.ml.id
  role_definition_name = "AcrPush"
  principal_id         = var.ml_pipeline_identity_principal_id
}
