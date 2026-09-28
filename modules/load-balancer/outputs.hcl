# -----------------------------------------------------------------------------
# load-balancer module: OUTPUTS
# -----------------------------------------------------------------------------

output "container" {
  value       = resource.container.lb
  description = "The nginx proxy container. Use it as a task, terminal or editor target."
}

output "terminal" {
  value       = resource.terminal.shell
  description = "Shell tab on the proxy."
}

output "service" {
  value       = resource.service.site
  description = "Browser tab showing whatever the proxy is serving (the live site)."
}

output "address" {
  value       = variable.ip_address
  description = "Static IP address of the proxy on the lab network."
}

output "config_path" {
  value       = "/etc/nginx/conf.d/default.conf"
  description = "Path of the generated nginx config inside the container."
}
