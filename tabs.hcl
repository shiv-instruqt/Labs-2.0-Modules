# -----------------------------------------------------------------------------
# Tabs owned by the lab.
#
# Most tabs in this lab come from the modules (see modules/*/tabs.hcl). These
# two show the other pattern: a lab-level tab that targets a module's resource
# through the module's output.
# -----------------------------------------------------------------------------

# Code editor opened on the load balancer's nginx config directory.
resource "editor" "lb_config" {
  workspace "nginx_config" {
    target    = module.lb.output.container
    directory = "/etc/nginx/conf.d"
  }
}

# Reference card for the module syntax used in this lab.
resource "note" "cheatsheet" {
  file = "notes/module-cheatsheet.md"
}
