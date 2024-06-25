# ctrlr.sh

A shell script that replaces the default `CTRL+r` behavior in `bash`. It uses `fzf` to select a command from `~/.bash_history` and insert the selected command into the prompt. It also copy the selected command to the clipboard, so you can paste it somewhere else.

The listing includes all `.bash_history` commands plus the commands executed in current session.

## Installation

1. Install `fzf` (your distro's packages repository _probably_ has it available to install)
2. (optional) Install `xclip` or `xsel` (your distro _probably_ has one of them already installed).
3. Copy the `ctrlr.sh` file to `/usr/local/bin/` (you can copy it to another directory if you wish)
4. Make it executable: `chmod +x /usr/local/bin/ctrlr.sh`
5. Override the vanilla `CTRL+r` adding the following line to the end of your `~/.bashrc`:
```
bind -x '"\C-r": "source /usr/local/bin/ctrlr.sh"'
```
6. Restart the terminal
7. Be happy

## License

`ctrlr.sh` is released under the [MIT License](https://opensource.org/licenses/MIT).
