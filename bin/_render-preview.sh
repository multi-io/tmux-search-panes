#!/usr/bin/env bash

TMP_PREVIEW_DIR="$1"
SELECTION="$2"

cat "$TMP_PREVIEW_DIR/$(echo $SELECTION | sed 's/ |.*//; s/:/--/g; s/\./--/g')"
