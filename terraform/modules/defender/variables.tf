variable "cluster_id" {
  type        = string
  description = "AKS cluster resource ID"
}

variable "enable_defender" {
  type        = bool
  default     = false
  description = "Enable Microsoft Defender for Containers. Set true in prod. Incurs cost."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = ""
  description = "Log Analytics workspace resource ID for Defender alert streaming. Required if enable_defender = true."

  validation {
    condition = (
      !var.enable_defender ||
      (var.enable_defender && var.log_analytics_workspace_id != "")
    )
    error_message = "log_analytics_workspace_id must be set when enable_defender is true."
  }
}
