#!/bin/bash

git checkout main

podman run -e 'DEBIAN_FRONTEND=noninteractive' -v ./dovecot.sources:/tmp/dovecot.sources:Z --name dovecot debian:trixie-slim /bin/bash -c "apt-get update > /dev/null && apt-get install -y curl apt-transport-https gpg > /dev/null && \
  curl https://repo.dovecot.org/DOVECOT-REPO-GPG-2.4 | gpg --dearmor -o /usr/share/keyrings/dovecot.gpg && \
  cp /tmp/dovecot.sources /etc/apt/sources.list.d/
  apt-get update > /dev/null && apt-cache policy dovecot-core | sed -n -e 's/^.*Candidate: //p' | tr -d '\n'" > version
podman rm dovecot

git add -A
git commit -m `cat version | cut -d~ -f 1 | cut -d+ -f 1 | cut -d: -f 2`
git push origin main
git tag -f `cat version | cut -d~ -f 1 | cut -d+ -f 1 | cut -d: -f 2`
git push origin -f `cat version | cut -d~ -f 1 | cut -d+ -f 1 | cut -d: -f 2`
