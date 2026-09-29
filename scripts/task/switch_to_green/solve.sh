#!/bin/bash
# Runs on: load balancer container
# Point proxy_pass at the green upstream and reload with no downtime.
set -e
CONF=/etc/nginx/conf.d/default.conf
sed -i -E 's#proxy_pass([[:space:]]+)http://[A-Za-z0-9_-]+;#proxy_pass\1http://green;#' "$CONF"
nginx -t
nginx -s reload
# Give the workers a moment to pick up the new config.
sleep 1
