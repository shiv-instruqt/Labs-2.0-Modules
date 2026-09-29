# =============================================================================
# Blue/Green Deployments, Built from Modules
#
# This file is the entrypoint. It does two things:
#   1. Pulls in the modules that build the lab (the module blocks below).
#   2. Defines the one `lab` resource: settings, default layout and content.
#
# Only top-level .hcl files are loaded automatically. Everything under
# modules/ is loaded only because a module block points at it.
# =============================================================================

# --- Modules -----------------------------------------------------------------

# The SAME module used twice. Each block gets its own copy of every resource
# inside, namespaced by the block name, so "blue" and "green" never collide.
module "blue" {
  source = "./modules/web-app"

  variables = {
    name         = "blue"
    version      = variable.blue_version
    accent_color = "#2563eb"
    network_id   = resource.network.main.meta.id
    ip_address   = "10.0.200.11"
  }
}

module "green" {
  source = "./modules/web-app"

  variables = {
    name         = "green"
    version      = variable.green_version
    accent_color = "#16a34a"
    network_id   = resource.network.main.meta.id
    ip_address   = "10.0.200.12"
  }
}

# Module CHAINING: the load balancer's inputs are the web-app modules' outputs.
# The platform works out the order for you: blue and green are created first.
module "lb" {
  source = "./modules/load-balancer"

  variables = {
    network_id     = resource.network.main.meta.id
    ip_address     = "10.0.200.10"
    active_backend = variable.live_color

    backends = {
      blue  = module.blue.output.address
      green = module.green.output.address
    }
  }
}

# --- Lab ---------------------------------------------------------------------

resource "lab" "main" {
  title       = "Blue/Green Deployments, Built from Modules"
  description = <<-EOT
    Run a blue/green release on nginx: find out which version is live, switch
    traffic to the new version with no downtime, and roll a hotfix forward.

    The environment is built from reusable Instruqt modules: one web-app module
    used twice (blue and green) and a load-balancer module wired to their
    outputs. The last chapter shows exactly how it fits together.

    Prerequisites: basic Linux command line. No nginx experience needed.
  EOT

  settings {
    timelimit {
      duration   = "45m"
      extend     = "15m"
      show_timer = true
    }

    idle {
      enabled      = true
      timeout      = "15m"
      show_warning = true
    }
  }

  layout = resource.layout.workbench

  content {
    title = "Lab guide"

    chapter "welcome" {
      title  = "Welcome"
      layout = resource.layout.reading

      page "overview" {
        reference = resource.page.overview
      }
    }

    chapter "release" {
      title = "Run the release"

      page "explore" {
        reference = resource.page.explore
      }

      page "switch" {
        reference = resource.page.switch
      }

      page "hotfix" {
        reference = resource.page.hotfix
      }
    }

    chapter "under_the_hood" {
      title  = "Under the hood"
      layout = resource.layout.reading

      page "anatomy" {
        reference = resource.page.anatomy
      }

      page "wiring" {
        reference = resource.page.wiring
      }

      page "recap" {
        reference = resource.page.recap
      }
    }
  }
}
