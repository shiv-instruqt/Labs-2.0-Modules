# =============================================================================
# TEST VARIANT: the same lab with NO modules.
# Everything the modules used to create now lives directly in sandbox.hcl and
# tabs.hcl. If this branch opens and the modules branch does not, the module
# loading path is what breaks the lab.
# =============================================================================

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
