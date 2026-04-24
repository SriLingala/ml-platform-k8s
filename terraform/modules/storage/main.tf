resource "azurerm_storage_account" "ml" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  # Disable public access — workloads access via Workload Identity
  public_network_access_enabled = false

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 30
    }

    container_delete_retention_policy {
      days = 7
    }
  }

  tags = var.tags
}

# Models bucket — stores registered model artefacts
resource "azurerm_storage_container" "models" {
  name                  = "models"
  storage_account_name  = azurerm_storage_account.ml.name
  container_access_type = "private"
}

# Data bucket — raw/processed training datasets
resource "azurerm_storage_container" "datasets" {
  name                  = "datasets"
  storage_account_name  = azurerm_storage_account.ml.name
  container_access_type = "private"
}

# MLflow artefacts bucket
resource "azurerm_storage_container" "mlflow" {
  name                  = "mlflow-artifacts"
  storage_account_name  = azurerm_storage_account.ml.name
  container_access_type = "private"
}

# Workload Identity — grant Storage Blob Data Contributor to the ML workload managed identity
resource "azurerm_role_assignment" "ml_workload_storage" {
  scope                = azurerm_storage_account.ml.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.ml_workload_identity_principal_id
}
