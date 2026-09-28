# web-app module

A single nginx instance that serves a coloured homepage and `/version.txt`.

## Inputs

| Variable | Default | Notes |
|---|---|---|
| `name` | `web` | **Required.** Instance name, network alias and homepage title |
| `version` | `0.0.0` | **Required.** Written to `/version.txt` as `<name> <version>` |
| `accent_color` | `#2563eb` | Homepage background colour |
| `network_id` | `""` | **Required.** `resource.network.<name>.meta.id` from the lab |
| `ip_address` | `""` | **Required.** Static IP inside that network's subnet |

## Outputs

| Output | Type | Use it for |
|---|---|---|
| `container` | container resource | task / terminal / editor `target` |
| `terminal` | terminal resource | layout tab `target` |
| `service` | service resource | layout tab `target` |
| `address` | string | other modules (e.g. load-balancer `backends`) |
| `hostname` | string | the network alias |
| `version` | string | display or checks |

## Example

```hcl
module "blue" {
  source = "./modules/web-app"

  variables = {
    name       = "blue"
    version    = "1.0.0"
    network_id = resource.network.main.meta.id
    ip_address = "10.0.200.11"
  }
}
```
