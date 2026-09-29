#!/bin/bash
# Runs on: load balancer container (condition-level target override)
EXPECTED="green ${HOTFIX_VERSION:-2.0.1}"
RESPONSE=$(curl -s --max-time 5 http://localhost/version.txt | tr -d '\r' | sed -e 's/[[:space:]]*$//')
echo "expected='${EXPECTED}' load balancer answered='${RESPONSE}'"
[ "$RESPONSE" = "$EXPECTED" ]
