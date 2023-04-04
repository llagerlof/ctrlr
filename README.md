# ctrlr.sh

A shell script that replaces the default `CTRL+r` behavior in `bash`. It uses `fzf` to select a command from `~/.bash_history` and copy it to the clipboard, so you can paste it anywhere.

## Installation

1. Install `fzf`
2. Install `xclip` or `xsel`
3. Copy the `ctrlr.sh` file to `/usr/local/bin/`
4. Make it executable: `chmod +x /usr/local/bin/ctrlr.sh`
5. Override the vanilla `CTRL+r` adding the following line to the end of your `~/.bashrc`:
```
bind -x '"\C-r": "/usr/local/bin/ctrlr.sh"'
```
6. Restart the terminal
7. Be happy

## License

`ctrlr.sh` is released under the [MIT License](https://opensource.org/licenses/MIT).
