#!/usr/bin/env bash

TMP_INDEX="$1"
TMP_PREVIEW_DIR="$2"

SELECTED=$(fzf --ansi \
  --prompt="Match: " \
  --preview-window=down:wrap:70% \
  --preview="$(dirname $0)/_render-preview.sh $TMP_PREVIEW_DIR {}" \
  < "$TMP_INDEX")

if [ -n "$SELECTED" ]; then
  TARGET=$(echo "$SELECTED" | cut -d' ' -f1)
  tmux switch-client -t "${TARGET%%:*}"
  tmux select-window -t "${TARGET%.*}"
  tmux select-pane -t "$TARGET"
fi

rm -f "$TMP_INDEX"
rm -rf "$TMP_PREVIEW_DIR"
