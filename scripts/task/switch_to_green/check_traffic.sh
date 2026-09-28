#!/bin/bash
# Runs on: load balancer container
# Asks the proxy (not green directly) so we test what real users see.
RESPONSE=$(curl -s --max-time 5 http://localhost/version.txt)
echo "load balancer answered: ${RESPONSE}"
[[ "$RESPONSE" == green* ]]
