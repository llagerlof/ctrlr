# ctrlr.fish
#
# fish shell integration for ctrlr.sh: searches the fish history with fzf and writes the
# selected command to the fish prompt (and to the clipboard).
#
# Version: 1.6.0
# Author:  Lawrence Lagerlof <llagerlof@gmail.com>
# GitHub:  http://github.com/llagerlof/ctrlr
# License: https://opensource.org/licenses/MIT
#
#
# Installation:
#
# 1. Install fzf
# 2. (optional) Install xclip or xsel
# 3. Copy ctrlr.sh to /usr/local/bin/ and make it executable: chmod +x /usr/local/bin/ctrlr.sh
# 4. Copy this file to ~/.config/fish/functions/ctrlr.fish
# 5. Override the vanilla CTRL+r adding the following line to the end of your ~/.config/fish/config.fish:
#
#    bind ctrl-r ctrlr          # fish 4.x key name
#    bind \cr ctrlr             # fish 3.x escape sequence
#
# 6. Restart the terminal
# 7. Be happy
#
# If ctrlr.sh is not in /usr/local/bin nor in your PATH, set its location in config.fish:
#
#    set -gx CTRLR_PATH /home/you/repos/ctrlr/ctrlr.sh

function ctrlr --description 'Search the fish history with fzf and write the selection to the prompt'
    # Locate ctrlr.sh
    set -l script $CTRLR_PATH
    if test -z "$script"
        set script (command -v ctrlr.sh)
    end
    if test -z "$script"; and test -r /usr/local/bin/ctrlr.sh
        set script /usr/local/bin/ctrlr.sh
    end
    if test -z "$script"; or not test -r "$script"
        echo (set_color red)"ctrlr.sh not found. Set CTRLR_PATH to its full path."(set_color normal) >&2
        commandline -f repaint
        return 1
    end

    # What is already typed in the prompt becomes the initial fzf query
    set -l query (commandline)

    # fish `history` prints the newest commands first, so it must not be reversed.
    # `string collect` keeps a multiline command as a single value.
    set -l selected (history | bash "$script" --newest-first --query "$query" | string collect)

    if test -n "$selected"
        # Replace the prompt content with the selected command and put the cursor at the end
        commandline -r -- $selected
        commandline -C (string length -- $selected)
    end

    commandline -f repaint
end
