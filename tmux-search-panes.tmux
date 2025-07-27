#!/usr/bin/env bash

tmux_option()
{
	local option="$1"
	local default_value="$2"
	local option_value=$(tmux show-option -gqv "$option")
	if [[ -z "$option_value" ]]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux bind "$(tmux_option "@open_search_panes_key" "v")" command-prompt -p "Search panes for:" "run-shell '${CURRENT_DIR}/bin/search-panes.sh %1'"
