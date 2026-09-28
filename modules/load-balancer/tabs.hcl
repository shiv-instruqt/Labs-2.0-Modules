# -----------------------------------------------------------------------------
# load-balancer module: TABS
# -----------------------------------------------------------------------------

resource "terminal" "shell" {
  target            = resource.container.lb
  shell             = "/bin/bash"
  working_directory = "/etc/nginx/conf.d"
}

resource "service" "site" {
  target = resource.container.lb
  scheme = "http"
  port   = 80
  path   = "/"
}
