#!/bin/sh

##### update-local-repo-arch
# Update my arch repository.
#
# Version 1 (2024-03-??)
# - Requires: repo-add

umask 0022
cd /usr/local/share/repo/arch/
chmod 644 *
repo-add metatron.db.tar.gz *.pkg.*
