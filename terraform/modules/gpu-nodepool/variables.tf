variable "cluster_id" {
  type        = string
  description = "AKS cluster resource ID"
}

variable "training_vm_size" {
  type        = string
  default     = "Standard_NC6s_v3"
  description = "VM size for training node pool — V100 GPU. Use Standard_NC24s_v3 for large models."
}

variable "inference_vm_size" {
  type        = string
  default     = "Standard_NC4as_T4_v3"
  description = "VM size for inference node pool — T4 GPU. Cost-efficient for serving."
}

variable "training_max_nodes" {
  type        = number
  default     = 4
  description = "Max nodes for spot training pool. Scale based on concurrent training jobs."
}

variable "inference_max_nodes" {
  type        = number
  default     = 3
  description = "Max nodes for on-demand inference pool."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Resource tags"
}
