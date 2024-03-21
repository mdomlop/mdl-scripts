#!/bin/sh

### flac_title_show
# Prints TITLE tag from a flac file. Useful for lazy people's scripts.
#
# Version 1 (2024-03-??)
# - Requires: metaflac

metaflac --show-tag=TITLE "$@"
