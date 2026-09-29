# -----------------------------------------------------------------------------
# web-app module: TABS
#
# A module can ship its own tabs. They are not shown until the consuming lab
# places them in a layout, using the outputs declared in outputs.hcl.
# -----------------------------------------------------------------------------

resource "terminal" "shell" {
  target            = resource.container.web
  shell             = "/bin/bash"
  working_directory = "/usr/share/nginx/html"
}

resource "service" "site" {
  target = resource.container.web
  scheme = "http"
  port   = 80
  path   = "/"
}
