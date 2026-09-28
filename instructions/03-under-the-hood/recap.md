# Recap and knowledge check

## What you did

- **Explored** a live system through its load balancer, before changing anything.
- **Switched** traffic from blue to green with `nginx -t` and `nginx -s reload`, with no downtime.
- **Rolled a hotfix forward** on green and verified it end to end, with blue untouched as a fallback.

## What the lab showed you about modules

| Concept | Where you saw it |
|---|---|
| **Reuse** | One `web-app` module became both blue and green |
| **Inputs** | `variables = { ... }` set the name, version, colour and IP of each copy |
| **Outputs** | `module.<block>.output.<name>` placed module tabs and targeted module containers |
| **Chaining** | Web-app outputs fed the load balancer's `backends` input |
| **Locals** | The load balancer turned a map into nginx upstreams |
| **Isolation** | The hotfix on green never touched blue |

## Try it yourself

After the lab, you could extend it in the repository:

1. Add a third instance: `module "canary"` with `source = "./modules/web-app"`, a new IP, and a `canary = module.canary.output.address` entry in `backends`.
2. Make green the default live colour by changing `live_color` in `variables.hcl`.
3. Publish `web-app` as a registry module and use it from another lab.

## Knowledge check

<instruqt-quiz id="modules_quiz"></instruqt-quiz>
