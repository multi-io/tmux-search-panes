#!/usr/bin/env bash

bind v command-prompt -p "Search panes for:" "run-shell '$HOME/.tmux/plugins/tmux-search-panes/bin/search-panes.sh %1'"
