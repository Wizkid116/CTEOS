#!/bin/bash
set -euo pipefail

#check if script is being run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

#run the version-check script
bash -E version-check.sh

LFS=/mnt/lfs
#ask the user for the drive
echo "Enter the installation path (e.g., /dev/sda1):"
lsblk
read DRIVE
echo "Enter the swap path:"
read SWAP_PATH
#unmount the drive if it's mounted
umount $DRIVE

#format the drive to ext4 (THIS WILL ERASE ALL DATA ON THE DRIVE)
mkfs.ext4 $DRIVE
mkswap $SWAP_PATH
echo $DRIVE >> variables
echo $DRIVE >> variables
echo $LFS >> variables

#make the LFS root directory, mount it, then download all files into sources directory
echo $LFS
mkdir -pv $LFS
mount -v -t ext4 $DRIVE
swapon $SWAP_PATH
mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
chown root:root $LFS/sources/*

#create the minimum required directory layout for LFS (the rest comes later)
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}
for i in bin lib sbin; do
ln -sv usr/$i $LFS/$i
done
case $(uname -m) in
x86_64) mkdir -pv $LFS/lib64 ;;
esac
mkdir -pv $LFS/tools

#make the LFS user
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
echo "Enter the password for the LFS user:"
passwd lfs

#grant full access of the LFS directories to the lfs user
chown -v lfs $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
x86_64) chown -v lfs $LFS/lib64 ;;
esac

#some distros have an instance of /etc/bash.bashrc. this can cause issues when building
#with the lfs user, so this will rename it temporarily.
[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE

echo "Preperation complete! Please run Stage-1.sh"
exit 0
