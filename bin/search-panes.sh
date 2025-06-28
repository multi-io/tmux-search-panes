#!/usr/bin/env bash

SEARCH_TERM="$1"

[ -z "$SEARCH_TERM" ] && exit

TMP_INDEX="$(mktemp)"
TMP_PREVIEW_DIR="$(mktemp -d)"

# Collect matching panes
while IFS= read -r session; do
  while IFS= read -r window; do
    while IFS= read -r pane; do
      id="$session:$window.$pane"
      content=$(tmux capture-pane -p -t "$id")j
      if echo "$content" | grep -iq -- "$SEARCH_TERM"; then
        preview_file="$TMP_PREVIEW_DIR/$session--$window--$pane"
        echo "$content" | grep -i -C 3 --color=always -- "$SEARCH_TERM" > "$preview_file"
        first_match=$(grep -i -m1 -- "$SEARCH_TERM" "$preview_file" | sed 's/^[[:space:]]*//')
        echo "$id | $first_match" >> "$TMP_INDEX"
      fi
    done < <(tmux list-panes -t "$session:$window" -F "#{pane_index}")
  done < <(tmux list-windows -t "$session" -F "#{window_index}")
done < <(tmux list-sessions -F "#{session_name}")

# Exit if no matches
if [ ! -s "$TMP_INDEX" ]; then
  rm -f "$TMP_INDEX"
  rm -rf "$TMP_PREVIEW_DIR"
  tmux display-message "No matches found for '$SEARCH_TERM'"
  exit
fi

tmux new-window "$(dirname $0)/_fzf-and-switch.sh" "$TMP_INDEX" "$TMP_PREVIEW_DIR"
