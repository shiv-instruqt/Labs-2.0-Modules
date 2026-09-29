# -----------------------------------------------------------------------------
# web-app module: OUTPUTS
#
# Outputs are the ONLY way a lab can reach into a module:
#   module.<block>.output.<name>
# Referencing module.<block>.resource.* from the lab is rejected by the
# validator, so anything the lab needs (containers for task targets, tabs for
# layouts, addresses for other modules) is exposed here.
# -----------------------------------------------------------------------------

output "container" {
  value       = resource.container.web
  description = "The nginx container. Use it as a task, terminal or editor target."
}

output "terminal" {
  value       = resource.terminal.shell
  description = "Shell tab on the container. Place it in a layout."
}

output "service" {
  value       = resource.service.site
  description = "Browser tab showing the homepage. Place it in a layout."
}

output "address" {
  value       = variable.ip_address
  description = "Static IP address of this instance on the lab network."
}

output "hostname" {
  value       = variable.name
  description = "Network alias of this instance."
}

output "version" {
  value       = variable.version
  description = "Version this instance serves."
}
