#!/bin/bash

# ctrlr.sh
#
# A shell script (bash) that replaces the default CTRL+r behavior.
# It uses fzf to select a command from ~/.bash_history and copy it to the clipboard, so you can paste it anywhere.
#
# Version: 1.4.2
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


# Check if fzf is installed
if ! command -v fzf >/dev/null 2>&1; then
  echo "fzf not found. Please install fzf first."
  exit 1
fi

# Read .bash_history and use fzf to select an item
selected_command=$(history | tac | awk '{$1=""; print substr($0, 2)}' | fzf -e --no-sort --query="$READLINE_LINE")

# If a command was selected, copy it to the clipboard and show the copied command
if [ -n "$selected_command" ]; then
  if command -v xclip >/dev/null 2>&1; then
    printf "%s" "$selected_command" | xclip -i -selection clipboard
  elif command -v xsel >/dev/null 2>&1; then
    printf "%s" "$selected_command" | xsel -i -b
  fi

  # Insert the selected command into the prompt and set the cursor position at the end of line
  READLINE_LINE="$selected_command"
  READLINE_POINT=${#READLINE_LINE}
fi
