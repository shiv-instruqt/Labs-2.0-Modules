# Anatomy of a module

A **module** is a reusable, parameterized piece of lab configuration. It can contain anything a lab can (containers, networks, tabs, pages, tasks, variables, outputs, even other modules) **except** the `lab` resource itself.

This lab's repository looks like this:

```text
.
├── main.hcl              ← module blocks + the lab resource
├── variables.hcl         ← lab-level inputs (versions, live colour)
├── sandbox.hcl           ← the shared network
├── tabs.hcl  layouts.hcl  pages.hcl  tasks.hcl  quizzes.hcl
├── instructions/  notes/  scripts/task/
└── modules/
    ├── web-app/          ← used twice: blue and green
    │   ├── variables.hcl   inputs
    │   ├── main.hcl        the nginx container
    │   ├── tabs.hcl        its terminal + service tab
    │   └── outputs.hcl     what the lab may use
    └── load-balancer/
        ├── variables.hcl
        ├── main.hcl        local + nginx proxy container
        ├── tabs.hcl
        └── outputs.hcl
```

> **Note:** The platform loads every `.hcl` file at the **top level** of the lab. Files under `modules/` are loaded **only** because a `module` block points at them.

## The three parts of a module

### 1. Inputs: `variable`

The module's settings. The lab fills them in; the module never hard-codes them.

```hcl
# modules/web-app/variables.hcl
variable "name" {
  default     = "web"
  description = "REQUIRED. Instance name (for example blue or green)."
}

variable "network_id" {
  default     = ""
  description = "REQUIRED. Pass resource.network.<name>.meta.id from the lab."
}
```

### 2. Resources

Ordinary lab resources that read their settings from `variable.*`:

```hcl
# modules/web-app/main.hcl
resource "container" "web" {
  image {
    name = "nginx:1.27"
  }

  environment = {
    APP_NAME    = variable.name
    APP_VERSION = variable.version
  }

  network {
    id         = variable.network_id
    ip_address = variable.ip_address
    aliases    = [variable.name]
  }
}
```

Inside a module, resources can reference **only that module's** own resources, variables and locals. Anything from outside comes in as a variable.

### 3. Outputs: `output`

The module's public face. **Outputs are the only thing a lab can reference** inside a module:

```hcl
# modules/web-app/outputs.hcl
output "container" { value = resource.container.web }    # a whole resource
output "terminal"  { value = resource.terminal.shell }   # a tab
output "address"   { value = variable.ip_address }       # a plain value
```

An output can hold a plain value (a string, a map) **or a whole resource**. Resource outputs are how the lab places a module's tabs in its layouts and points tasks at a module's containers.

## Isolation

When the lab uses `web-app` twice, every resource is namespaced by its module block:

```text
module.blue.resource.container.web
module.green.resource.container.web
```

Same code, two independent containers. That's why your hotfix on green left blue at 1.0.0.

Next: how the lab plugs these modules together.
