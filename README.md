# Dotfiles
Remote repository for my personal dotfiles.

## Requirements
Install the following dependencies:
```text
# pacman -S git stow
```

## Installation
First, clone this remote repository in your $HOME directory using git:
```text
$ git clone git@github.com/MisterKartoffel/.dotfiles.git $HOME
$ cd .dotfiles
```

Then use GNU Stow to create the necessary symlinks:
```text
$ stow .
```

## Caveats
If you run into a conflict error when Stow-ing the configuration, you need to remove the conflicting local files:
```text
$ mv /path/to/conflicting/files /path/to/conflicting/files.bak
$ stow .
```
