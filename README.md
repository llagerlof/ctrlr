# ctrlr.sh

A shell script that replaces the default `CTRL+r` behavior in `bash`. It uses `fzf` to select a command from `~/.bash_history` and insert the selected command into the prompt. It also copy the selected command to the clipboard, so you can paste it somewhere else.

The listing includes all `.bash_history` commands plus the commands executed in current session.

## Installation

First, install the dependencies:

1. Install `fzf` (your distro's package repository _probably_ has it available)
2. (optional) Install `xclip` or `xsel` if you want clipboard integration

Then install `ctrlr.sh` using one of these options.

### Install only for the current user

If `~/.local/bin` is not already on your `PATH`, add it before using the user-local install options.

#### Option 1: clone the repository and symlink the script into `~/.local/bin`

```bash
mkdir -p ~/repos ~/.local/bin
git clone https://github.com/llagerlof/ctrlr.git ~/repos/ctrlr
chmod +x ~/repos/ctrlr/ctrlr.sh
ln -sf ~/repos/ctrlr/ctrlr.sh ~/.local/bin/ctrlr.sh
```

If you prefer `~/repositories`, replace `~/repos/ctrlr` with `~/repositories/ctrlr`.

#### Option 2: download the script directly into `~/.local/bin`

Before running the download command, review <https://raw.githubusercontent.com/llagerlof/ctrlr/master/ctrlr.sh> to make sure you trust its contents.

```bash
mkdir -p ~/.local/bin
curl -fsSL https://raw.githubusercontent.com/llagerlof/ctrlr/master/ctrlr.sh -o ~/.local/bin/ctrlr.sh
chmod +x ~/.local/bin/ctrlr.sh
```

### Install for everyone

#### Option 3: clone the repository into a normal user's home directory and symlink it into `/usr/local/bin`

```bash
mkdir -p ~/repos
git clone https://github.com/llagerlof/ctrlr.git ~/repos/ctrlr
chmod +x ~/repos/ctrlr/ctrlr.sh
sudo ln -sf ~/repos/ctrlr/ctrlr.sh /usr/local/bin/ctrlr.sh
```

If you prefer `~/repositories`, replace `~/repos/ctrlr` with `~/repositories/ctrlr`.

#### Option 4: download the script directly into `/usr/local/bin`

Before running the download command, review <https://raw.githubusercontent.com/llagerlof/ctrlr/master/ctrlr.sh> to make sure you trust its contents.

```bash
sudo curl -fsSL https://raw.githubusercontent.com/llagerlof/ctrlr/master/ctrlr.sh -o /usr/local/bin/ctrlr.sh
sudo chmod +x /usr/local/bin/ctrlr.sh
```

After installing the script, override the vanilla `CTRL+r` by adding the matching line to the end of your `~/.bashrc`:

- User-local install:

```bash
bind -x '"\C-r": "source ~/.local/bin/ctrlr.sh"'
```

- System-wide install:

```bash
bind -x '"\C-r": "source /usr/local/bin/ctrlr.sh"'
```

Then restart the terminal.

## License

`ctrlr.sh` is released under the [MIT License](https://opensource.org/licenses/MIT).
