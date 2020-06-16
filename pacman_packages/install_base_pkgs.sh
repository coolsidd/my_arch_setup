#!/usr/bin/env bash
set -euo pipefail

ROOT_UID=0     # Only users with $UID 0 have root privileges.
E_NOTROOT=87   # Non-root exit error.
BASE_PKG_LIST='./pkglist_official.txt'
# Run as root
if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "Must be root to run this script."
  exit $E_NOTROOT
fi

echo "Installing files..."

pacman --noconfirm -Sq $(cat $BASE_PKG_LIST)

echo "Open visudo? (Y/n)"
read open_now
while true;
do
case $open_now in
  "y" | "Y")
      visudo
      break
;;
  "n"|"N")
      break
;;
  *)
      echo "Enter 'y' or 'n'"
      echo "Open visudo? (Y/n)"
      read open_now
;;    
esac
done  
                 
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
