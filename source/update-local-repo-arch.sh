#!/bin/sh
umask 0022
cd /usr/local/share/repo/arch/
chmod 644 *
repo-add metatron.db.tar.gz *.pkg.*
