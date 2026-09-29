# -----------------------------------------------------------------------------
# Tabs owned by the lab.
#
# TEST VARIANT (no modules): the terminal and service tabs that used to ship
# inside the modules are defined here directly.
# -----------------------------------------------------------------------------

# Code editor opened on the load balancer's nginx config directory.
resource "editor" "lb_config" {
  workspace "nginx_config" {
    target    = resource.container.lb
    directory = "/etc/nginx/conf.d"
  }
}

# Reference card for the module syntax used in this lab.
resource "note" "cheatsheet" {
  file = "notes/module-cheatsheet.md"
}

resource "terminal" "lb" {
  target            = resource.container.lb
  shell             = "/bin/bash"
  working_directory = "/etc/nginx/conf.d"
}

resource "service" "lb" {
  target = resource.container.lb
  scheme = "http"
  port   = 80
  path   = "/"
}

resource "terminal" "blue" {
  target            = resource.container.blue
  shell             = "/bin/bash"
  working_directory = "/usr/share/nginx/html"
}

resource "service" "blue" {
  target = resource.container.blue
  scheme = "http"
  port   = 80
  path   = "/"
}

resource "terminal" "green" {
  target            = resource.container.green
  shell             = "/bin/bash"
  working_directory = "/usr/share/nginx/html"
}

resource "service" "green" {
  target = resource.container.green
  scheme = "http"
  port   = 80
  path   = "/"
}
