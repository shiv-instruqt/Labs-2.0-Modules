# -----------------------------------------------------------------------------
# Knowledge check on the module concepts used in this lab.
# -----------------------------------------------------------------------------

resource "quiz" "modules" {
  questions = [
    resource.single_choice_question.module_reference,
    resource.single_choice_question.reuse,
    resource.multiple_choice_question.module_contents,
    resource.single_choice_question.local_source,
  ]

  show_hints   = true
  show_answers = true
}

resource "single_choice_question" "module_reference" {
  question = "In this lab, the layout places the blue shell with target = ???. What goes in place of ???"
  answer   = "module.blue.output.terminal"

  distractors = [
    "module.blue.resource.terminal.shell",
    "resource.terminal.shell",
    "variable.blue.terminal",
  ]

  hints = [
    "A lab can only reach inside a module through what the module chooses to expose.",
  ]
}

resource "single_choice_question" "reuse" {
  question = "The blue and green instances come from the same web-app module. What makes them different?"
  answer   = "The variables passed in each module block"

  distractors = [
    "Two copies of the module directory",
    "A separate network for each instance",
    "The order of the module blocks in main.hcl",
  ]

  hints = [
    "Look at the variables map in module \"blue\" and module \"green\" in main.hcl.",
  ]
}

resource "multiple_choice_question" "module_contents" {
  question = "Which of these can a module contain?"

  answer = [
    "Containers and networks",
    "Terminal and service tabs",
    "Instruction pages",
    "Variables and outputs",
  ]

  distractors = [
    "Its own lab resource with chapters",
  ]

  hints = [
    "A module can contain everything a lab can, except one thing.",
  ]
}

resource "single_choice_question" "local_source" {
  question = "Which source value loads a module from inside this lab's own repository?"
  answer   = "./modules/web-app"

  distractors = [
    "github.com/acme/labs//modules/web-app",
    "modules/web-app",
    "instruqt/web-app",
  ]

  hints = [
    "Local sources must start with ./ or ../ and stay inside the lab directory.",
    "team/slug addresses (like instruqt/web-app) are for published registry modules.",
  ]
}
