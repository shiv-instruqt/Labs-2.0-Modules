# -----------------------------------------------------------------------------
# web-app module: INPUTS
#
# Variables are the module's public interface. The consuming lab sets them in
# the `variables = { ... }` map of its `module "..." {}` block.
#
# Every variable has a default so the module parses on its own. The ones marked
# REQUIRED have placeholder defaults that the lab must override.
# -----------------------------------------------------------------------------

variable "name" {
  default     = "web"
  description = "REQUIRED. Instance name, used as the network alias and shown on the homepage (for example blue or green)."
}

variable "version" {
  default     = "0.0.0"
  description = "REQUIRED. Application version this instance serves. Written to /version.txt."
}

variable "accent_color" {
  default     = "#2563eb"
  description = "Hex colour used for the homepage background."
}

variable "network_id" {
  default     = ""
  description = "REQUIRED. ID of the network to attach to. Pass resource.network.<name>.meta.id from the lab."
}

variable "ip_address" {
  default     = ""
  description = "REQUIRED. Static IP address on that network. Must be inside the network subnet."
}
