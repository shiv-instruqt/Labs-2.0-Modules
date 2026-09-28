#!/bin/bash
# Runs on: load balancer container
# EXPECTED_COLOR is set from the lab variable live_color (see tasks.hcl).
EXPECTED="${EXPECTED_COLOR:-blue}"

# Accept "blue", "Blue", " blue " or "blue 1.0.0": compare the first word only.
ANSWER=$(tr '[:upper:]' '[:lower:]' < /root/live-color.txt 2>/dev/null | awk 'NF {print $1; exit}')

echo "expected=${EXPECTED} answer=${ANSWER}"
[ "$ANSWER" = "$EXPECTED" ]
