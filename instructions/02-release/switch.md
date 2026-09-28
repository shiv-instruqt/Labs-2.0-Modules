# Switch traffic to green

Green is running **2.0.0** and passed its checks. Time to cut over.

In a blue/green release you don't touch the running apps. You change **where the load balancer sends traffic**, and nginx can take that change without dropping a single connection.

## 1. Edit the config

Open the **LB config** tab and open `default.conf`, or edit it from the **Load balancer** shell:

```bash
sed -n '/location \/ {/,/}/p' /etc/nginx/conf.d/default.conf
```

Change the `proxy_pass` line from:

```nginx
proxy_pass http://blue;
```

to:

```nginx
proxy_pass http://green;
```

If you prefer a one-liner:

```bash
sed -i 's#proxy_pass http://blue;#proxy_pass http://green;#' /etc/nginx/conf.d/default.conf
```

## 2. Test, then reload

Always check the config before applying it. A broken config never reaches users this way:

```bash
nginx -t
```

Then reload gracefully. New workers pick up the config and old workers finish the requests they're already handling:

```bash
nginx -s reload
```

## 3. Verify

```bash
curl -s localhost/version.txt
curl -sI localhost | grep -i x-served-by
```

Refresh the **Live site** tab. It should turn green.

> **Tip:** **Rollback** is the same edit in reverse: point `proxy_pass` back at `blue` and reload. That's the main reason teams use blue/green deployments.

## Your task

<instruqt-task id="switch_to_green">
Point the load balancer at the `green` upstream and reload nginx. Both the config and live traffic are checked.
</instruqt-task>
