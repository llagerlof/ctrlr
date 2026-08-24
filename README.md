# ctrlr.sh

A shell script that replaces the default `CTRL+r` behavior in `bash` (also supports `fish`).

It uses `fzf` to select a command from `~/.bash_history` and insert the selected command into the prompt. It also copy the selected command to the clipboard, so you can paste it somewhere else.

The listing includes all `.bash_history` commands plus the commands executed in current session.

## Installation (bash)

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

## Installation (fish)

`ctrlr.fish` is a small fish function that calls `ctrlr.sh` and writes the selected command to the fish prompt.

1. Install `fzf`
2. (optional) Install `xclip` or `xsel`
3. Copy `ctrlr.sh` to `/usr/local/bin/` and make it executable: `chmod +x /usr/local/bin/ctrlr.sh`
4. Copy `ctrlr.fish` to `~/.config/fish/functions/ctrlr.fish`
5. Override the vanilla `CTRL+r` adding the following line to the end of your `~/.config/fish/config.fish`:
```
bind ctrl-r ctrlr
```
6. Restart the terminal
7. Be happy

If `ctrlr.sh` is not in `/usr/local/bin` nor in your `PATH`, point `CTRLR_PATH` to it in `config.fish`:
```
set -gx CTRLR_PATH /home/you/repos/ctrlr/ctrlr.sh
```

Binding `CTRL+r` directly to the pipeline (`bind ctrl-r 'history | ctrlr.sh'`) does not work: fish prints the result instead of putting it in the prompt. The prompt can only be filled by fish's `commandline` builtin, which is what `ctrlr.fish` does.

## Reading the history from stdin

`ctrlr.sh` also accepts a history list on stdin. When stdin is not a terminal, the lines are read from there instead of the current shell history, and the selected command is printed to stdout (it is still copied to the clipboard):

```
cat ~/.bash_history | ctrlr.sh
ctrlr.sh < ~/.bash_history
selected=$(cat ~/.bash_history | ctrlr.sh)
grep git ~/.bash_history | ctrlr.sh
```

Options:

| Option | Description |
| --- | --- |
| `--query STRING` | Start `fzf` with this query. Defaults to what is already typed in the bash prompt. |
| `--newest-first` | The history received on stdin is already sorted from the newest to the oldest command, so it is not reversed. This is what fish's `history` outputs. |
| `--oldest-first` | The history received on stdin is sorted from the oldest to the newest command, so it is reversed to list the newest commands first. This is the default, and it is how `~/.bash_history` is sorted. |

Lines that are `HISTTIMEFORMAT` timestamps (like `#1712345678`) are ignored. The `CTRL+r` binding described above is unaffected: when stdin is the terminal, the current shell history is used as always.

## License

`ctrlr.sh` is released under the [MIT License](https://opensource.org/licenses/MIT).
