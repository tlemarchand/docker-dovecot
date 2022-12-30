#!/bin/bash

git checkout main

podman run --name dovecot debian:bullseye-slim /bin/bash -c "apt-get update > /dev/null && apt-get install -y curl apt-transport-https gpg > /dev/null && \
  curl https://repo.dovecot.org/DOVECOT-REPO-GPG | gpg --import && \
  gpg --export ED409DA1 > /etc/apt/trusted.gpg.d/dovecot.gpg && \
  echo 'deb https://repo.dovecot.org/ce-2.3-latest/debian/bullseye bullseye main' > /etc/apt/sources.list.d/dovecot.list && \
  apt-get update > /dev/null && apt-cache policy dovecot-core | sed -n -e 's/^.*Candidate: //p' | tr -d '\n'" > version
podman rm dovecot

git add -A
git commit -m `cat version`
git push origin main
git tag -f `cat version`
git push origin -f `cat version`