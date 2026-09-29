# -----------------------------------------------------------------------------
# Layouts. TEST VARIANT (no modules): every tab target is a lab resource.
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
        target = resource.terminal.lb
        active = true
      }

      tab "lb_config" {
        title  = "LB config"
        target = resource.editor.lb_config
      }

      tab "blue_shell" {
        title  = "Blue shell"
        target = resource.terminal.blue
      }

      tab "green_shell" {
        title  = "Green shell"
        target = resource.terminal.green
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
        target = resource.service.lb
        active = true
      }

      tab "blue_site" {
        title  = "Blue (direct)"
        target = resource.service.blue
      }

      tab "green_site" {
        title  = "Green (direct)"
        target = resource.service.green
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
      target = resource.service.lb
    }
  }
}
