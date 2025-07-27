#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux bind v command-prompt -p "Search panes for:" "run-shell '${CURRENT_DIR}/bin/search-panes.sh %1'"
