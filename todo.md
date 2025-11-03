# Upgrade from Debian Bullseye to Bookworm

## Task Progress

- [x] Update Dockerfile to use Debian bookworm slim image
- [x] Remove dovecot.sources file
- [x] Update Dockerfile to use bookworm-backports repository
- [x] Update release.sh to use bookworm instead of bullseye
- [x] Update version file to reflect new Debian version
- [x] Test the changes

## Changes Made

1. Updated FROM line in Dockerfile from `debian:bullseye-slim` to `debian:bookworm-slim`
2. Removed dovecot.sources file 
3. Updated Dockerfile to use Debian bookworm-backports repository instead of dovecot.org repository
4. Updated release.sh to use bookworm instead of bullseye
5. Corrected repository URL to use "http://deb.debian.org/debian bookworm-backports main"
6. Restored COPY commands in Dockerfile that were accidentally removed
7. Version file updated to reflect the new Debian version (2:2.3.21.1-2+debian12)
