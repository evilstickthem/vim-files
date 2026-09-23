#!/bin/bash
# Symlink dotfiles into $HOME. Safe to re-run. Works on macOS and Linux (remote boxes).
set -e

FOLDER="$(cd "$(dirname "$0")" && pwd)"

link() {  # link <repo-file> <target>; backs up an existing real file once
  if [ -e "$2" ] && [ ! -L "$2" ]; then mv "$2" "$2.pre-dotfiles.bak"; fi
  mkdir -p "$(dirname "$2")"
  ln -sfn "$FOLDER/$1" "$2"
}

# dotfiles
link vimrc          ~/.vimrc
link tmuxconf       ~/.tmux.conf
link irbrc          ~/.irbrc
link zshrc          ~/.zshrc
link starship.toml  ~/.config/starship.toml
if [ "$(uname)" != "Darwin" ]; then
  link bashrc        ~/.bashrc
  link bash_profile  ~/.bash_profile
fi
# ln -sf  "$FOLDER"/gitconfig     ~/.gitconfig
echo "Setup symlinks"

# iTerm2 profile (macOS)
if [ -d "$HOME/Library/Application Support/iTerm2" ]; then
  link iterm2/Dev.json "$HOME/Library/Application Support/iTerm2/DynamicProfiles/Dev.json"
  echo "Linked iTerm2 Dev profile"
fi

# reload tmux config if a server is running
tmux source-file ~/.tmux.conf 2>/dev/null && echo "Reload tmux config" || true

# vim (plugins install on first launch via vim-plug)
mkdir -p ~/.vimbackup ~/.vimtmp ~/.vimundo
# vim-plug needs a tty; `script` fakes one so this works non-interactively
script -q /dev/null vim -u ~/.vimrc +'PlugInstall --sync' +'qa!' </dev/null >/dev/null 2>&1 || true
echo "Setup vim"
