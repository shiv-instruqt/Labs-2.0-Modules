# Roll a hotfix forward

Minutes after the release, product reports a small bug in 2.0.0. The fix is ready as **2.0.1**. Green is live, so you'll patch green in place and leave blue untouched as your fallback.

## 1. Patch green

Switch to the **Green shell** tab. You're in green's web root:

```bash
pwd
cat version.txt
```

Ship the hotfix by updating the version file:

```bash
echo "green 2.0.1" > /usr/share/nginx/html/version.txt
```

Optionally, update the homepage too, so the browser tab shows it:

```bash
sed -i 's/version 2.0.0/version 2.0.1/' /usr/share/nginx/html/index.html
```

nginx serves static files straight from disk, so no reload is needed.

## 2. Prove users get it

A fix only counts when users receive it. Go back to the **Load balancer** tab and ask through the proxy:

```bash
curl -s localhost/version.txt
```

Refresh the **Live site** tab as well.

## 3. Confirm blue is untouched

```bash
curl -s 10.0.200.11/version.txt
```

Blue still reports **1.0.0**. Both instances come from the same `web-app` module, but each is a separate, isolated copy, so changing one never affects the other.

## Your task

<instruqt-task id="hotfix_green">
Update green to `green 2.0.1` and make sure users receive it through the load balancer. This task checks two different containers: green directly, and the load balancer.
</instruqt-task>
