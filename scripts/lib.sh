#!/usr/bin/env bash
#
# Helper functions
#

# List of dependencies to run Spellbook.
DEPS=(fzf)
readonly DEPS

# Print an error message to stderr and exit.
function err() {
  local timestamp
  local error
  local delay=2000
  # Assemble the message with a timestamp.
  timestamp="$(date +"%Y-%m-%d %H:%M:%S")"
  error="$timestamp ERROR: $*"
  # Print the message to stderr.
  echo "$error" >&2
  # Display the message in tmux if we're in a tmux session.
  if [[ -n "$TMUX" ]]; then 
    tmux display-message -d $delay "$error"
  fi
  # Leave the message on the screen for a while.
  sleep $((delay / 1000))
  # Exit with an error code.
  exit 1
}

# Check if the dependencies are satisfied.
function check_deps() {
  local dep
  for dep in "${DEPS[@]}"; do
    if ! command -v "$dep" >/dev/null 2>&1; then
      err "Missing dependency: $dep"
    fi
  done
}

# Get the current value of a tmux option, or the default value if not set.
function get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value
  option_value="$(tmux show-option -gqv "$option")"
  if [[ -z "$option_value" ]]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

# Get the value an option should be set to.
function get_option() {
  local option="$1"

  case "$option" in
    "@spellbook-key")
      get_tmux_option "$option" "s"
      ;;
    "@spellbook-spells-file")
      get_tmux_option "$option" "${HOME}/.local/share/spellbook/spells"
      ;;
    # TODO: editor, window size, single/all pane keys, etc.
    *)
      err "Unknown option: $option"
      ;;
  esac
}
