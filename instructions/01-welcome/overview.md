# Welcome

Your team is shipping **version 2.0.0** of a web app. Version 1.0.0 is serving users right now, and nobody wants downtime. You'll do what production teams do: run a **blue/green deployment**.

- **Blue** runs the current release (1.0.0).
- **Green** runs the new release (2.0.0), already up but getting no traffic.
- A **load balancer** decides which one users reach.

The cutover is one config change and a reload. Blue keeps running, so rolling back is just as quick.

## What you'll do

1. **Explore.** Find out which instance is live, using only the load balancer.
2. **Switch.** Point the load balancer at green and reload nginx with no downtime.
3. **Hotfix.** Patch green in place and prove that users get the fix.

Your work is checked automatically at each step.

## The environment

```text
                    ┌──────────────────────────┐
     users  ──────► │  lb        10.0.200.10   │   module "lb"
                    │  nginx reverse proxy     │   (load-balancer)
                    └───────┬─────────┬────────┘
                   live     │         │   standby
                ┌───────────▼──┐  ┌───▼──────────┐
                │ blue  1.0.0  │  │ green 2.0.0  │   module "blue" and module "green"
                │ 10.0.200.11  │  │ 10.0.200.12  │   (the same web-app module, used twice)
                └──────────────┘  └──────────────┘
                        network "main"  10.0.200.0/24
```

## Your tabs

| Tab | What it is |
|---|---|
| **Load balancer** | Shell on the nginx proxy, opened in `/etc/nginx/conf.d` |
| **LB config** | Code editor on the proxy's config directory |
| **Blue shell** / **Green shell** | Shells on each app instance, opened in the web root |
| **Live site** | What users see, through the load balancer |
| **Blue (direct)** / **Green (direct)** | Each instance, bypassing the load balancer |
| **Module cheat sheet** | Quick reference for the module syntax behind this lab |

## Built from modules

You never see it as a user, but this lab is assembled from **Instruqt modules**: reusable, parameterized building blocks. Blue and green are two copies of one `web-app` module, and the load balancer is a separate module that is fed their addresses. The **Under the hood** chapter shows exactly how.

Click **Next** when you're ready.
