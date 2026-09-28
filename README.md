# Blue/Green Deployments, Built from Modules

An Instruqt 2.0 lab that shows how **modules** work by using them to build a real scenario. Learners run a blue/green release on nginx. Authors reading the repo see modules used for reuse, inputs, outputs, chaining and isolation.

`instruqt lab validate` passes: ✅ `Lab is valid`

---

## What the learner does (about 30 min)

| Chapter | Page | Activity | Checked on |
|---|---|---|---|
| Welcome | Welcome | Scenario, architecture, tab tour | none |
| Run the release | Explore the environment | Task `identify_live`: find the live instance, write it to `/root/live-color.txt` | load balancer |
| | Switch traffic to green | Task `switch_to_green`: edit `proxy_pass`, run `nginx -t`, reload | load balancer (config and live traffic) |
| | Roll a hotfix forward | Task `hotfix_green`: bump green to 2.0.1, verify through the proxy | green **and** load balancer (per-condition target) |
| Under the hood | Anatomy of a module | How a module is laid out | none |
| | How the modules are wired together | Reuse, chaining, output references | none |
| | Recap and knowledge check | 4-question quiz | none |

Every condition has a `solve` script, so every step can be skipped.

## Architecture

```text
                    ┌──────────────────────────┐
     users  ──────► │  lb        10.0.200.10   │   module "lb"     ./modules/load-balancer
                    └───────┬─────────┬────────┘
                   live     │         │   standby
                ┌───────────▼──┐  ┌───▼──────────┐
                │ blue  1.0.0  │  │ green 2.0.0  │   module "blue" + module "green"
                │ 10.0.200.11  │  │ 10.0.200.12  │   ./modules/web-app (same source, used twice)
                └──────────────┘  └──────────────┘
                   resource "network" "main"  10.0.200.0/24   (owned by the lab)
```

## Repository layout

```text
.
├── main.hcl            module blocks ("blue", "green", "lb") + the lab resource
├── variables.hcl       lab inputs: blue_version, green_version, live_color, hotfix_version
├── sandbox.hcl         the shared network
├── tabs.hcl            lab-owned tabs: an editor and a note that target module outputs
├── layouts.hcl         "workbench" (default) and "reading" layouts
├── pages.hcl           page resources + activity mappings
├── tasks.hcl           3 tasks, 6 conditions
├── quizzes.hcl         4 questions
├── instructions/       markdown for every page
├── notes/              module cheat sheet (note tab)
├── scripts/task/       check + solve scripts, one folder per task
├── assets/
└── modules/
    ├── web-app/        variables.hcl · main.hcl · tabs.hcl · outputs.hcl
    └── load-balancer/  variables.hcl · main.hcl · tabs.hcl · outputs.hcl
```

## Module concepts demonstrated

| Concept | Where |
|---|---|
| **Local module source** | `source = "./modules/web-app"` in `main.hcl` |
| **Reuse (same module twice)** | `module "blue"` and `module "green"` |
| **Inputs** | `modules/*/variables.hcl`, set via `variables = { ... }` |
| **Lab values passed in** | `network_id = resource.network.main.meta.id`, `version = variable.blue_version` |
| **Outputs as plain values** | `module.blue.output.address` |
| **Outputs as whole resources** | `module.lb.output.container`, `module.blue.output.terminal` |
| **Chaining (module → module)** | `backends = { blue = module.blue.output.address, ... }` in `module "lb"` |
| **Locals + for-expressions in a module** | `local "upstream_blocks"` in `modules/load-balancer/main.hcl` |
| **Tabs shipped inside a module** | `modules/*/tabs.hcl`, placed by `layouts.hcl` |
| **Lab tabs targeting module resources** | `resource "editor" "lb_config"` in `tabs.hcl` |
| **Task and condition targets in modules** | `tasks.hcl`, including a per-condition target override |
| **Lab variables into task scripts** | `config.environment` in `tasks.hcl` |
| **Isolation / namespacing** | The hotfix changes green only; blue stays 1.0.0 |

## Push and import

```bash
cd instruqt-modules-lab
chmod +x scripts/task/*/*.sh          # keep the task scripts executable in git
git init && git branch -m main
git add . && git commit -m "Blue/green lab built from modules"
git remote add origin git@github.com:<you>/instruqt-modules-lab.git
git push -u origin main
```

Then in Instruqt: **Labs → Import lab** → pick the repository → branch `main` → root directory `/` → confirm. Later pushes sync automatically.

> **Note:** Create the GitHub repository **empty** (no README, licence or .gitignore) to avoid a merge conflict on the first push.

## Validate locally

The public CLI has a `lab` command group that isn't listed in `--help`:

```bash
instruqt lab validate .     # offline check of HCL, references and activity mappings
instruqt lab format .       # canonical formatting (this repo is already formatted)
```

## Test checklist (after import)

1. Start the lab. **Live site** should be blue, **Blue (direct)** blue, **Green (direct)** green.
2. Load balancer tab: `curl -s localhost/version.txt` → `blue 1.0.0`.
3. `echo blue > /root/live-color.txt` → task 1 passes. Try `green` first to see the failure message.
4. Run the sed one-liner **without** a reload: the config condition passes and the traffic condition fails. Then `nginx -s reload`: both pass.
5. Green shell: `echo "green 2.0.1" > /usr/share/nginx/html/version.txt` → both hotfix conditions pass.
6. Skip each task on a fresh session to confirm every solve script works.

## Tested before delivery

- `instruqt lab validate` → valid (CLI build 2426-665ffd3).
- Both modules' `command` heredocs and the `upstream_blocks` local were rendered with the real HashiCorp HCL library, and the output was inspected.
- The three instances were simulated with network and mount namespaces on a `10.0.200.0/24` bridge running nginx. Every task's check scripts were run in the right instance for both the passing and the failing case, and every solve script was run, including a syntax-error config and a `green` that appears only in a comment.

## Design decisions and caveats

- **The modules contain no file paths.** Their start-up logic is inline (`command` with a heredoc), so they don't depend on how module paths are resolved. At the time of writing, the runtime resolves module-relative paths against the module's directory, but CLI `lab validate` (build 2426) still resolves them from the lab root. A module that ships its own `pages/*.md` can therefore validate differently locally and on the platform. Task scripts, pages and notes live at the lab root and are unaffected.
- **The lab only references module outputs.** `module.X.resource.*` from the lab is rejected by the validator. Anything the lab needs is exposed in `outputs.hcl`.
- **nginx uses IP addresses, not DNS names.** The config never depends on alias DNS. The aliases `blue`, `green` and `lb` are still set, and the explore page mentions them.
- **Conservative field set.** No `icon` on the lab (it previously broke lab starts), no `type` on variables, no task `prerequisites` and no explicit `theme`. These are newer schema fields, left out to avoid runtime "Unsupported argument" errors. Every variable has a default for the same reason. `REQUIRED` in its description marks the inputs the lab must set.
- **Images:** `nginx:1.27` (Debian-based, includes `bash` and `curl`, which the scripts need).

## Extend it

1. **Canary:** add `module "canary" { source = "./modules/web-app" ... ip_address = "10.0.200.13" }` and `canary = module.canary.output.address` in the lb `backends` map. You'll get a third upstream with no module changes.
2. **Start on green:** set `live_color = "green"` in `variables.hcl`. Task 1 follows it through `EXPECTED_COLOR`. The later tasks' narrative assumes blue.
3. **Registry module:** move `modules/web-app` to its own repository, import it under **Building blocks → Modules**, publish version `1.0.0`, then change both blocks to `source = "<team>/web-app"` and `version = "1.0.0"`. `version` is required for registry sources and not allowed for local ones.

## References

- Modules: https://docs.labs.instruqt.com/reference/types/module/
- Lab structure (module loading rules): https://docs.labs.instruqt.com/introduction/lab-structure/
- Lab / Page / Task / Layout: https://docs.labs.instruqt.com/reference/content/
- Container / Network / Terminal / Service / Editor: https://docs.labs.instruqt.com/reference/sandbox/
- GitHub import: https://docs.labs.instruqt.com/version-control/integrating-external-vcs/
- Official `minimal` CLI template (`instruqt lab init --template minimal`): uses a local module and output references
