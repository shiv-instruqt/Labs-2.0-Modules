# -----------------------------------------------------------------------------
# load-balancer module: INPUTS
#
# Every variable has a default so the module parses on its own. The ones marked
# REQUIRED have placeholder defaults that the lab must override.
# -----------------------------------------------------------------------------

variable "network_id" {
  default     = ""
  description = "REQUIRED. ID of the network to attach to. Pass resource.network.<name>.meta.id from the lab."
}

variable "ip_address" {
  default     = ""
  description = "REQUIRED. Static IP address on that network. Must be inside the network subnet."
}

variable "backends" {
  default     = {}
  description = "REQUIRED. Map of backend name => IP address. Each entry becomes an nginx upstream with that name."
}

variable "active_backend" {
  default     = "blue"
  description = "Name of the backend (a key in backends) that receives traffic when the lab starts."
}
