#!/bin/sh

##### flac_tag_show
# Prints selected tag from a flac file.
#
# Version 1 (2024-03-??)
# - Requires: metaflac

metaflac --export-tags-to=- "$@"
