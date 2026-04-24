resource "azurerm_security_center_subscription_pricing" "defender_containers" {
  tier          = "Standard"
  resource_type = "ContainerRegistry"
}

resource "azurerm_security_center_subscription_pricing" "defender_kubernetes" {
  tier          = "Standard"
  resource_type = "KubernetesService"
}

# Enable Defender for Containers on the AKS cluster
resource "azurerm_kubernetes_cluster_extension" "defender" {
  count = var.enable_defender ? 1 : 0

  name           = "microsoft-defender-for-containers"
  cluster_id     = var.cluster_id
  extension_type = "microsoft.azuredefender.kubernetes"

  configuration_settings = {
    "logAnalyticsWorkspaceResourceID" = var.log_analytics_workspace_id
    "auditLogPath"                    = "/var/log/kube-apiserver/audit.log"
  }
}

# Diagnostic settings — stream Defender alerts to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "defender_alerts" {
  count = var.enable_defender && var.log_analytics_workspace_id != "" ? 1 : 0

  name               = "defender-alerts-to-law"
  target_resource_id = var.cluster_id

  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "kube-audit"
  }

  enabled_log {
    category = "kube-audit-admin"
  }

  enabled_log {
    category = "guard"
  }

  metric {
    category = "AllMetrics"
    enabled  = false
  }
}
