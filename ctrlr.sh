#!/bin/bash

# ctrlr.sh
#
# A shell script (bash) that replaces the default CTRL+r behavior.
# It uses fzf to select a command from ~/.bash_history and copy it to the clipboard, so you can paste it anywhere.
#
# Version: 1.5.0
# Author:  Lawrence Lagerlof <llagerlof@gmail.com>
# GitHub:  http://github.com/llagerlof/ctrlr
# License: https://opensource.org/licenses/MIT
#
#
# Installation:
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
# Usage:
#
# - Sourced (the CTRL+r binding above): the current shell history is listed.
# - Piped: the history is read from stdin and the selected command is printed to stdout. Examples:
#
#    cat ~/.bash_history | ctrlr.sh
#    ctrlr.sh < ~/.bash_history
#    selected=$(cat ~/.bash_history | ctrlr.sh)


# Check if fzf is installed
if ! command -v fzf >/dev/null 2>&1; then
  echo "fzf not found. Please install fzf first."
  exit 1
fi

# Get the history from stdin when it is not a terminal (piped or redirected), otherwise use the shell history.
# The history file may contain HISTTIMEFORMAT timestamp lines (#1712345678), so they are discarded.
if [ -t 0 ]; then
  history_list=$(history | awk '{$1=""; print substr($0, 2)}')
  history_from_stdin=0
else
  history_list=$(grep -v '^#[0-9]\{9,\}$')
  history_from_stdin=1
fi

# Use fzf to select an item (fzf reads the keyboard from /dev/tty, so it works inside a pipeline too)
selected_command=$(printf '%s\n' "$history_list" | tac | awk '!seen[$0]++' | fzf -e --no-sort --query="$READLINE_LINE")

# If a command was selected, copy it to the clipboard and show the copied command
if [ -n "$selected_command" ]; then
  if command -v xclip >/dev/null 2>&1; then
    printf "%s" "$selected_command" | xclip -i -selection clipboard >/dev/null 2>&1
  elif command -v xsel >/dev/null 2>&1; then
    printf "%s" "$selected_command" | xsel -i -b >/dev/null 2>&1
  fi

  # When the history came from stdin, print the selection so it can be captured by the caller
  if [ "$history_from_stdin" -eq 1 ]; then
    printf "%s\n" "$selected_command"
  fi

  # Insert the selected command into the prompt and set the cursor position at the end of line
  READLINE_LINE="$selected_command"
  READLINE_POINT=${#READLINE_LINE}
fi
