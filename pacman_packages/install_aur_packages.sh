#!/usr/bin/env bash
set -euo pipefail

ROOT_UID=0     # Only users with $UID 0 have root privileges.
E_ROOT=87   # Root exit error.
PKG_LIST_LOC=$PWD'/foreignpkglist.txt'
HOME_LOC=$HOME

AUR_LOC=$HOME_LOC'/AUR'
# Run as root
if [ "$UID" -eq "$ROOT_UID" ]
then
  echo "Must not be root to run this script."
  exit $E_ROOT
fi

make_aur_packages ()
{
    for package in *
    do
        echo "installing $package"
        cd "./"$package
        echo $PWD
        makepkg -si
        cd $AUR_LOC
    done
}

echo "Cloning files..."
echo "Installing auracle"
mkdir -p $AUR_LOC
cd $AUR_LOC
rm -rf auracle-git
git clone https://aur.archlinux.org/auracle-git.git
cd './auracle-git'
makepkg -si

echo 'cloning AUR packages'
cd $AUR_LOC
auracle clone $(cat $PKG_LIST_LOC)
echo "Make packages? (Y/n)"
read make_packages
while true;
do
case $make_packages in
  "y" | "Y")
      make_aur_packages
      break
;;
  "n"|"N")
      break
;;
  *)
      echo "Enter 'y' or 'n'"
      echo "Make packages? (Y/n)"
      read make_packages
;;    
esac
done  


exit

