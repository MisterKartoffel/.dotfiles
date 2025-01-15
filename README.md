# Dotfiles
Remote repository for my personal dotfiles.

## Requirements
Install the following dependencies:
```sh
# pacman -S git stow
```

## Installation
First, clone this remote repository in your $HOME directory using git:
```sh
$ git clone git@github.com/MisterKartoffel/.dotfiles.git $HOME
$ cd .dotfiles
```

Then use GNU Stow to create the necessary symlinks:
```sh
$ stow .
```

## Caveats
If you run into a conflict error when Stow-ing the configuration, you need to remove the conflicting local files:
```sh
$ mv /path/to/conflicting/files /path/to/conflicting/files.bak
$ stow .
```
