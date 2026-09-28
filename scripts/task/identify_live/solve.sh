#!/bin/bash
# Runs on: load balancer container
# Ask the load balancer which instance answers, and record it.
curl -s --max-time 5 http://localhost/version.txt | awk '{print $1}' > /root/live-color.txt
cat /root/live-color.txt
