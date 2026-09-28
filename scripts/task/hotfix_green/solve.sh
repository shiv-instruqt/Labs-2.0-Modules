#!/bin/bash
# Runs on: green container
echo "green ${HOTFIX_VERSION:-2.0.1}" > /usr/share/nginx/html/version.txt
sed -i "s#version [0-9][0-9.]*#version ${HOTFIX_VERSION:-2.0.1}#" /usr/share/nginx/html/index.html
