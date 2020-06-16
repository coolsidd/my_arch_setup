#!/usr/bin/env bash
set -euo pipefail

ROOT_UID=0     # Only users with $UID 0 have root privileges.
E_NOTROOT=87   # Non-root exit error.

# Run as root
if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "Must be root to run this script."
  exit $E_NOTROOT
fi

echo "Installing files..."

pacman --noconfirm -Sq $(cat ./pkglist_official.txt)

echo "Enabling common services..."

systemctl enable NetworkManager.service
systemctl enable lightdm.service
systemctl enable pkgfile-update.timer

echo "Updating databases..."
updatedb
pkgfile -u
pacman -F
fc-cache -fv
echo "Done!"

exit
