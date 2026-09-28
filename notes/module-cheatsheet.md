# Module cheat sheet

## Use a module

```hcl
module "blue" {
  source = "./modules/web-app"      # local: starts with ./ or ../
  # source  = "acme/web-app"        # registry: team-slug/module-slug
  # version = "~> 1.2"              # required for registry, not allowed for local

  variables = {
    name       = "blue"
    network_id = resource.network.main.meta.id
  }
}
```

## Write a module

| File | Holds |
|---|---|
| `variables.hcl` | `variable "x" { default = ... }`: the inputs |
| `main.hcl` | resources that read `variable.x` |
| `tabs.hcl` | terminals, services, editors |
| `outputs.hcl` | `output "y" { value = ... }`: what the lab may use |

## Reference syntax

| From | To | Syntax |
|---|---|---|
| lab | lab resource | `resource.container.web` |
| lab | module output | `module.blue.output.container` |
| module | its own resource | `resource.container.web` |
| module | its own input | `variable.name` |
| lab | module resource | ❌ not allowed, expose it as an output |

## Rules to remember

- Only **top-level** `.hcl` files load. `modules/*` loads through `module` blocks.
- Modules can nest up to **10** levels.
- Same module twice? Every resource is namespaced by the block name.
- A module has **no** `lab` resource: no chapters, time limit or default layout.
- Validate before you push: `instruqt lab validate`

## Commands used in this lab

| Command | Does |
|---|---|
| `curl -s localhost/version.txt` | Ask the proxy which version answers |
| `curl -sI localhost \| grep -i x-served-by` | Show which backend served the request |
| `nginx -t` | Test the nginx config |
| `nginx -s reload` | Apply the config with no downtime |
