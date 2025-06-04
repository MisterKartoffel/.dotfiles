# Dotfiles
Remote repository for my personal dotfiles.

## Requirements
Install the following dependencies:
```text
# pacman -S git
```

## Installation
First, clone this remote repository in your `$HOME` directory using git:
```text
$ git clone git@github.com/MisterKartoffel/.dotfiles.git $HOME
$ cd .dotfiles
```

Verify that all files are correct and move the directory to `$HOME/.config`:
```text
$ mv $HOME/.config{,.bak}
$ mv $HOME/.{dotfiles,config}
```

Finally, manually symlink `.zshenv` to `$HOME`:
```text
$ ln -sf ./.zshenv $HOME/.zshenv
```

Then, follow system-wide configuration instructions listed in `$HOME/.config/notes.md`.
