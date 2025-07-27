# Fulltext Search Across All Tmux Panes

Tmux plugin that allows you to perform a fulltext search across the live contents of all panes in all windows in all running sessions.

![tmux-search-panes Demo GIF](./screenrec.gif)

## Usage

Hit `prefix` + `@open_search_panes_key` (default: v), enter regex to search for.
Plugin finds all panes in all windows/sessions containing the expression, then opens a live search (fzf) with previews to further drill down into the results.
Hit Enter to open the selected pane, or Escape to abort.

## Installation

### Requirements

- [GNU bash](https://www.gnu.org/software/bash/)
- [fzf](https://github.com/junegunn/fzf/)

### Using [TPM](https://github.com/tmux-plugins/tpm/)

Add this line to your `~/.tmux.conf`

```tmux
set -g @plugin 'multi-io/tmux-search-panes'
```

Reload configuration, then press `prefix` + `I`.

### Manually

Clone the repo somewhere, add `run-shell ~/clone/path/tmux-search-panes.tmux` to your `tmux.conf`.

### License

[MIT](LICENSE.md)
