#!/usr/bin/env bash

# Prompt user for search term
SEARCH_TERM="$(tmux command-prompt -p "Search panes for:")"

[ -z "$SEARCH_TERM" ] && exit

TMP_INDEX=$(mktemp)
trap "rm -f $TMP_INDEX" EXIT
TMP_PREVIEW_DIR=$(mktemp -d)
trap "rm -rf $TMP_PREVIEW_DIR" EXIT

# Collect matching panes
while IFS= read -r session; do
  while IFS= read -r window; do
    while IFS= read -r pane; do
      id="$session:$window.$pane"
      content=$(tmux capture-pane -p -t "$id")
      if echo "$content" | grep -iq "$SEARCH_TERM"; then
        preview_file="$TMP_PREVIEW_DIR/$session--$window--$pane"
        echo "$content" | grep -i -C 3 --color=always "$SEARCH_TERM" > "$preview_file"
        first_match=$(grep -i -m1 "$SEARCH_TERM" "$preview_file" | sed 's/^[[:space:]]*//')
        echo "$id | $first_match" >> "$TMP_INDEX"
      fi
    done < <(tmux list-panes -t "$session:$window" -F "#{pane_index}")
  done < <(tmux list-windows -t "$session" -F "#{window_index}")
done < <(tmux list-sessions -F "#{session_name}")

# Exit if no matches
if [ ! -s "$TMP_INDEX" ]; then
  tmux display-message "No matches found for '$SEARCH_TERM'"
  exit
fi

# Use fzf with preview
SELECTED=$(fzf --ansi \
  --prompt="Match: " \
  --preview-window=down:wrap:70% \
  --preview='cat "'"$TMP_PREVIEW_DIR"'"/$(echo {} | sed "s/ |.*//; s/:/--/g; s/\./--/g")' \
  < "$TMP_INDEX")

if [ -n "$SELECTED" ]; then
  TARGET=$(echo "$SELECTED" | cut -d' ' -f1)
  tmux switch-client -t "${TARGET%%:*}"
  tmux select-window -t "${TARGET%.*}"
  tmux select-pane -t "$TARGET"
fi
