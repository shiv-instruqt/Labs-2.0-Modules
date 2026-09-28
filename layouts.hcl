# -----------------------------------------------------------------------------
# Layouts. Tabs that come from a module are placed with
#   target = module.<block>.output.<output>
# which is the only way a lab can address something inside a module.
# -----------------------------------------------------------------------------

# Hands-on layout (the lab default): instructions on the left, shells on the
# top right, live browsers on the bottom right.
resource "layout" "workbench" {
  column {
    width = 35

    instructions {}
  }

  column {
    width = 65

    row {
      height = 60

      tab "lb_shell" {
        title  = "Load balancer"
        target = module.lb.output.terminal
        active = true
      }

      tab "lb_config" {
        title  = "LB config"
        target = resource.editor.lb_config
      }

      tab "blue_shell" {
        title  = "Blue shell"
        target = module.blue.output.terminal
      }

      tab "green_shell" {
        title  = "Green shell"
        target = module.green.output.terminal
      }

      tab "cheatsheet" {
        title  = "Module cheat sheet"
        target = resource.note.cheatsheet
      }
    }

    row {
      height = 40

      tab "live_site" {
        title  = "Live site"
        target = module.lb.output.service
        active = true
      }

      tab "blue_site" {
        title  = "Blue (direct)"
        target = module.blue.output.service
      }

      tab "green_site" {
        title  = "Green (direct)"
        target = module.green.output.service
      }
    }
  }
}

# Reading layout for the concept chapters: wide instructions plus the cheat sheet.
resource "layout" "reading" {
  column {
    width = 60

    instructions {}
  }

  column {
    width = 40

    tab "cheatsheet" {
      title  = "Module cheat sheet"
      target = resource.note.cheatsheet
      active = true
    }

    tab "live_site" {
      title  = "Live site"
      target = module.lb.output.service
    }
  }
}
