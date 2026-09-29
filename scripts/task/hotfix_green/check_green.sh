#!/bin/bash
# Runs on: green container (task-level target)
# HOTFIX_VERSION is set from the lab variable hotfix_version (see tasks.hcl).
EXPECTED="green ${HOTFIX_VERSION:-2.0.1}"
ACTUAL=$(tr -d '\r' < /usr/share/nginx/html/version.txt 2>/dev/null | sed -e 's/[[:space:]]*$//' | head -n1)
echo "expected='${EXPECTED}' actual='${ACTUAL}'"
[ "$ACTUAL" = "$EXPECTED" ]
