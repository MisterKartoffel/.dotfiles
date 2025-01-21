# Dotfiles
Remote repository for my personal dotfiles.

## Requirements
Install the following dependencies:
```text
# pacman -S git stow
```

## Installation
First, clone this remote repository in your `$HOME` directory using git:
```text
$ git clone git@github.com/MisterKartoffel/.dotfiles.git $HOME
$ cd .dotfiles
```

Then use GNU Stow to create the necessary symlinks:
```text
$ stow .
```

Finally, manually symlink `.zshenv` to `$HOME`:
```text
$ ln -sf ./.zshenv $HOME/.zshenv
```

## Caveats
If you run into a conflict error when Stow-ing the configuration, you need to remove the conflicting local files:
```text
# Either moving or copying conflicting files works, for example:
$ mv /path/to/conflicting/files{,.bak}

# Then, stow as normal:
$ stow .
```
