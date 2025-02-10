#!/usr/bin/env bash
#
# Loader for Spellbook.
#

# Get the current working directory.
cwd="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load the helper library.
source "${cwd}/scripts/lib.sh"

# If we aren't in a tmux session, exit.
[[ -z "$TMUX" ]] && err "Not in a tmux session."

# Check the dependencies.
check_deps

# Get the key to run Spellbook, default to 's'.
spellbook_key="$(get_tmux_option "@spellbook-key" "s")"

# Bind the key to run Spellbook.
if [[ -n "$spellbook_key" ]]; then
  tmux bind "$spellbook_key" run-shell "\"${cwd}/scripts/run\" \"#{pane_id}\""
fi
