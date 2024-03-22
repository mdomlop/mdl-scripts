#!/bin/sh

##### flac_artist_show
# Prints ARTIST tag from a flac file. Useful for lazy people's scripts.
#
# Version 1 (2024-03-??)
# - Requires: metaflac

metaflac --show-tag=ARTIST "$@"
