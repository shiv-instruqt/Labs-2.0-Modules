# Explore the environment

Before changing anything, find out what is actually serving traffic. Work in the **Load balancer** tab.

## 1. Read the load balancer config

The config was generated when the lab started. Print it:

```bash
cat /etc/nginx/conf.d/default.conf
```

You'll see:

- Two `upstream` blocks, `blue` and `green`, each pointing at an instance's IP address.
- One `server` block whose `proxy_pass` line decides where traffic goes.

## 2. Ask the load balancer who answers

Every instance serves a tiny `/version.txt` file. Request it **through the proxy**:

```bash
curl -s localhost/version.txt
```

The proxy also stamps each response with the address of the backend it used:

```bash
curl -sI localhost | grep -i x-served-by
```

## 3. Talk to each instance directly

Bypass the proxy and ask each instance for itself:

```bash
curl -s 10.0.200.11/version.txt
curl -s 10.0.200.12/version.txt
```

Both are up. Only one of them is live.

> **Note:** Each instance also has a network alias, so `curl -s blue/version.txt` and `curl -s green/version.txt` should work too. The config uses IP addresses on purpose, so it never depends on DNS.

Look at the **Live site**, **Blue (direct)** and **Green (direct)** tabs to see the same thing in a browser.

## Your task

<instruqt-task id="identify_live">
Write the name of the instance that is serving live traffic, and nothing else, to `/root/live-color.txt` on the load balancer. For example: `echo NAME > /root/live-color.txt`
</instruqt-task>
