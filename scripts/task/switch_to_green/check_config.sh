#!/bin/bash
# Runs on: load balancer container
CONF=/etc/nginx/conf.d/default.conf

# The active proxy_pass line (ignoring comments) must point at the green upstream.
grep -v '^[[:space:]]*#' "$CONF" | grep -Eq 'proxy_pass[[:space:]]+http://green;' || exit 1

# The config must also be valid, otherwise a reload would fail.
nginx -t >/dev/null 2>&1
