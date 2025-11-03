#!/bin/bash

git checkout main

podman run -e 'DEBIAN_FRONTEND=noninteractive' --name dovecot debian:bookworm-slim /bin/bash -c "apt-get update > /dev/null && apt-get install -y curl apt-transport-https gpg > /dev/null && \
  echo \"deb http://deb.debian.org/debian bookworm-backports main\" > /etc/apt/sources.list.d/backports.list && \
  apt-get update > /dev/null && apt-cache -t bookworm-backports policy dovecot-core | sed -n -e 's/^.*Candidate: //p' | tr -d '\n'" > version
podman rm dovecot

git add -A
git commit -m `cat version | cut -d~ -f 1 | cut -d+ -f 1 | cut -d: -f 2`
git push origin main
git tag -f `cat version | cut -d~ -f 1 | cut -d+ -f 1 | cut -d: -f 2`
git push origin -f `cat version | cut -d~ -f 1 | cut -d+ -f 1 | cut -d: -f 2`
