#!/bin/bash
set -euo pipefail
LFS=/mnt/lfs
#check if script is being run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

#give root access to the LFS filesystem
chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
x86_64) chown -R root:root $LFS/lib64 ;;
esac

#make and mount the rest of the lfs filesystem
mkdir -pv $LFS/{dev,proc,sys,run}
mount -v --bind /dev $LFS/dev
mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
if [ -h $LFS/dev/shm ]; then
install -v -d -m 1777 $LFS$(realpath /dev/shm)
else
mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi

#copy the stage 3 and chroot scripts to the LFS root directory.
cp stage-3.sh $LFS
cp variables $LFS/install-scripts
cp -R chroot-scripts $LFS/install-scripts

chroot "$LFS" /usr/bin/env -i \
HOME=/root                    \
TERM="$TERM"                  \
PS1='(lfs chroot) \u:\w\$ '   \
PATH=/usr/bin:/usr/sbin       \
MAKEFLAGS="-j$(nproc)"        \
TESTSUITEFLAGS="-j$(nproc)"   \
/bin/bash -c "/stage-3.sh"
