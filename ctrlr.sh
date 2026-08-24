#!/bin/bash

# ctrlr.sh
#
# A shell script (bash) that replaces the default CTRL+r behavior.
# It uses fzf to select a command from ~/.bash_history and copy it to the clipboard, so you can paste it anywhere.
#
# Version: 1.6.0
# Author:  Lawrence Lagerlof <llagerlof@gmail.com>
# GitHub:  http://github.com/llagerlof/ctrlr
# License: https://opensource.org/licenses/MIT
#
#
# Installation (bash):
#
# 1. Install fzf
# 2. (optional) Install xclip or xsel
# 3. Copy this file to /usr/local/bin/
# 4. Make it executable: chmod +x /usr/local/bin/ctrlr.sh
# 5. Override the vanilla CTRL+r adding the following line to the end of your .bashrc:
#
#    bind -x '"\C-r": "source /usr/local/bin/ctrlr.sh"'
#
# 6. Restart the terminal
# 7. Be happy
#
#
# Installation (fish):
#
# See ctrlr.fish, the fish function that calls this script and fills the fish prompt.
#
#
# Usage:
#
#   ctrlr.sh [--query STRING] [--newest-first | --oldest-first]
#
# - Sourced (the CTRL+r binding above): the current shell history is listed and the selected
#   command is written to the bash prompt (READLINE_LINE).
# - Piped: the history is read from stdin and the selected command is printed to stdout. Examples:
#
#    cat ~/.bash_history | ctrlr.sh
#    ctrlr.sh < ~/.bash_history
#    selected=$(cat ~/.bash_history | ctrlr.sh)
#
# Options:
#
#   --query STRING   Start fzf with this query (defaults to the current bash prompt content).
#   --newest-first   The history received on stdin is already sorted from newest to oldest
#                    (fish's `history` does that), so it is not reversed.
#   --oldest-first   The history received on stdin is sorted from oldest to newest, so it is
#                    reversed to show the newest commands first. This is the default.


# Detect if this script was sourced (CTRL+r binding) or executed, to never kill the user shell on error
ctrlr_sourced=0
if [ "${BASH_SOURCE[0]}" != "$0" ]; then
  ctrlr_sourced=1
fi

# Defaults: the fzf query is the text already typed in the bash prompt and the history is reversed
ctrlr_query="$READLINE_LINE"
ctrlr_order="tac"

# Parse the options. Unknown arguments are ignored because a sourced script inherits the
# positional parameters of the calling shell.
while [ $# -gt 0 ]; do
  case "$1" in
    --query)
      ctrlr_query="$2"
      shift
      [ $# -gt 0 ] && shift
      ;;
    --query=*)
      ctrlr_query="${1#--query=}"
      shift
      ;;
    --newest-first)
      ctrlr_order="cat"
      shift
      ;;
    --oldest-first)
      ctrlr_order="tac"
      shift
      ;;
    *)
      shift
      ;;
  esac
done

# Check if fzf is installed
if ! command -v fzf >/dev/null 2>&1; then
  echo "fzf not found. Please install fzf first." >&2
  if [ "$ctrlr_sourced" -eq 1 ]; then
    return 1
  fi
  exit 1
fi

# Get the history from stdin when it is not a terminal (piped or redirected), otherwise use the shell history.
# The history file may contain HISTTIMEFORMAT timestamp lines (#1712345678), so they are discarded.
if [ -t 0 ]; then
  ctrlr_history=$(history | awk '{$1=""; print substr($0, 2)}')
  ctrlr_from_stdin=0
else
  ctrlr_history=$(grep -v '^#[0-9]\{9,\}$')
  ctrlr_from_stdin=1
fi

# Use fzf to select an item (fzf reads the keyboard from /dev/tty, so it works inside a pipeline too)
selected_command=$(printf '%s\n' "$ctrlr_history" | "$ctrlr_order" | awk '!seen[$0]++' | fzf -e --no-sort --query="$ctrlr_query")

# If a command was selected, copy it to the clipboard and show the copied command
if [ -n "$selected_command" ]; then
  if command -v xclip >/dev/null 2>&1; then
    printf "%s" "$selected_command" | xclip -i -selection clipboard >/dev/null 2>&1
  elif command -v xsel >/dev/null 2>&1; then
    printf "%s" "$selected_command" | xsel -i -b >/dev/null 2>&1
  fi

  # When the history came from stdin, print the selection so it can be captured by the caller
  if [ "$ctrlr_from_stdin" -eq 1 ]; then
    printf "%s\n" "$selected_command"
  fi

  # Insert the selected command into the prompt and set the cursor position at the end of line
  READLINE_LINE="$selected_command"
  READLINE_POINT=${#READLINE_LINE}
fi

unset ctrlr_sourced ctrlr_query ctrlr_order ctrlr_history ctrlr_from_stdin
