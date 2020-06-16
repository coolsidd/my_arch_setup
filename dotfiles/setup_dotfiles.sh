#!/usr/bin/env bash
set -euo pipefail

ROOT_UID=0
E_NOTROOT=87   # Non-root exit error.

# Run as root, of course.
if [ "$UID" -eq "$ROOT_UID" ]
then
  echo "Don't run this script as root!"
  exit $E_NOTROOT
fi 

HOME_DIR=$HOME"/test"
CONF_DIR=$HOME_DIR"/.config"
EMACS_DIR=$HOME_DIR"/.doom.d"

echo "Copying dotfiles..."
mkdir -p $CONF_DIR
cp -rf ./config/* -t $CONF_DIR
echo "Dotfiles copied to "$CONF_DIR

echo "Installing emacs..."
mkdir -p $EMACS_DIR
cp -rf ./doom.d/* -t $EMACS_DIR
git clone --depth 1 https://github.com/hlissner/doom-emacs $HOME_DIR/.emacs.d
$HOME_DIR/.emacs.d/bin/doom install

echo "Doom emacs installed"

exit
