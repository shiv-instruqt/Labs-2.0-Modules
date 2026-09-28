# How the modules are wired together

Everything connects in `main.hcl`. A `module` block says **where** the module is (`source`) and **what to set it to** (`variables`).

## Reuse: one module, two instances

```hcl
module "blue" {
  source = "./modules/web-app"

  variables = {
    name         = "blue"
    version      = variable.blue_version        # "1.0.0"
    accent_color = "#2563eb"
    network_id   = resource.network.main.meta.id
    ip_address   = "10.0.200.11"
  }
}

module "green" {
  source = "./modules/web-app"                 # same source...

  variables = {
    name         = "green"                     # ...different inputs
    version      = variable.green_version      # "2.0.0"
    accent_color = "#16a34a"
    network_id   = resource.network.main.meta.id
    ip_address   = "10.0.200.12"
  }
}
```

Variable values are expressions evaluated **in the lab**, so they can use the lab's own variables (`variable.blue_version`) and resources (`resource.network.main.meta.id`).

## Chaining: outputs feed other modules

The load balancer doesn't know blue or green exist. It just receives a map of backends, and the lab fills that map from the web-app outputs:

```hcl
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
```

Because `lb` references `module.blue` and `module.green`, the platform builds them first. You never write the order yourself.

Inside the module, a **local** turns that map into nginx config:

```hcl
local "upstream_blocks" {
  value = join("\n", [for name, address in variable.backends :
    "upstream ${name} { server ${address}:80; }"])
}
```

Add a third entry to `backends` and a third upstream appears. The module itself doesn't change.

## Consuming outputs in the lab

Every place the lab touches a module goes through `module.<block>.output.<name>`:

| Where | Expression |
|---|---|
| Layout tab | `target = module.blue.output.terminal` |
| Layout tab | `target = module.lb.output.service` |
| Editor workspace | `target = module.lb.output.container` |
| Task target | `target = module.lb.output.container` |
| Condition override | `config { target = module.green.output.container }` |

Referencing `module.blue.resource.container.web` directly is **rejected** by `instruqt lab validate`:

```text
invalid module reference "module.blue.resource.terminal.shell":
a module's outputs are read as module.NAME.output.OUTPUT
```

## Local vs registry modules

| | Local module (this lab) | Registry module |
|---|---|---|
| `source` | `./modules/web-app` | `team-slug/module-slug` |
| `version` | not allowed | required, e.g. `1.2.0` or `~> 1.2` |
| Lives in | this lab's repository | its own repository, published as versions |
| Use when | splitting one lab's config | sharing a building block across labs and teams |

To share `web-app` with other labs, you would move it to its own repository, import it under **Building blocks → Modules**, publish a version, and change `source` to your team's address with a `version`.
