# -----------------------------------------------------------------------------
# Pages. Each page points at a markdown file and maps the activity IDs used
# in that file (<instruqt-task id="...">) to task and quiz resources.
# -----------------------------------------------------------------------------

resource "page" "overview" {
  title = "Welcome"
  file  = "instructions/01-welcome/overview.md"
}

resource "page" "explore" {
  title = "Explore the environment"
  file  = "instructions/02-release/explore.md"

  activities = {
    identify_live = resource.task.identify_live
  }
}

resource "page" "switch" {
  title = "Switch traffic to green"
  file  = "instructions/02-release/switch.md"

  activities = {
    switch_to_green = resource.task.switch_to_green
  }
}

resource "page" "hotfix" {
  title = "Roll a hotfix forward"
  file  = "instructions/02-release/hotfix.md"

  activities = {
    hotfix_green = resource.task.hotfix_green
  }
}

resource "page" "anatomy" {
  title = "Anatomy of a module"
  file  = "instructions/03-under-the-hood/anatomy.md"
}

resource "page" "wiring" {
  title = "How the modules are wired together"
  file  = "instructions/03-under-the-hood/wiring.md"
}

resource "page" "recap" {
  title = "Recap and knowledge check"
  file  = "instructions/03-under-the-hood/recap.md"

  activities = {
    modules_quiz = resource.quiz.modules
  }
}
