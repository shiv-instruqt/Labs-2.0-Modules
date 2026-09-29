# load-balancer module

An nginx reverse proxy. One `upstream` is generated per entry in `backends`, and traffic goes to `active_backend`.

## Inputs

| Variable | Default | Notes |
|---|---|---|
| `network_id` | `""` | **Required.** `resource.network.<name>.meta.id` from the lab |
| `ip_address` | `""` | **Required.** Static IP inside that network's subnet |
| `backends` | `{}` | **Required.** Map of `name => IP`, e.g. `{ blue = "10.0.200.11" }` |
| `active_backend` | `blue` | Key of `backends` that receives traffic at start |

## Outputs

| Output | Type | Use it for |
|---|---|---|
| `container` | container resource | task / terminal / editor `target` |
| `terminal` | terminal resource | layout tab `target` |
| `service` | service resource | layout tab `target` ("live site") |
| `address` | string | the proxy's IP |
| `config_path` | string | `/etc/nginx/conf.d/default.conf` |

## Example

```hcl
module "lb" {
  source = "./modules/load-balancer"

  variables = {
    network_id     = resource.network.main.meta.id
    ip_address     = "10.0.200.10"
    active_backend = "blue"
    backends = {
      blue  = module.blue.output.address
      green = module.green.output.address
    }
  }
}
```

To switch traffic at runtime: edit `proxy_pass` in the config, then `nginx -t && nginx -s reload`.
