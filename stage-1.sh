#!/bin/bash
set -euo pipefail
MAKEFLAGS=$(nproc)

if ! test $(whoami) == "lfs" ; then
    echo "Please run as lfs user"
    exit 1
fi

#create lfs user bash_profile
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

#create new bashrc
cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF

#source the new bash_profile
source ~/.bash_profile

bash -e build-scripts/binutils-pass-1.sh
bash -e build-scripts/gcc-pass-1.sh
bash -e build-scripts/linux-headers.sh
bash -e build-scripts/glibc.sh
bash -e build-scripts/libstdcpp-pass-1.sh
bash -e build-scripts/m4.sh
bash -e build-scripts/ncurses.sh
bash -e build-scripts/bash.sh
bash -e build-scripts/coreutils.sh
bash -e build-scripts/diffutils.sh
bash -e build-scripts/file.sh
bash -e build-scripts/findutils.sh
bash -e build-scripts/gawk.sh
bash -e build-scripts/grep.sh
bash -e build-scripts/gzip.sh
bash -e build-scripts/make.sh
bash -e build-scripts/patch.sh
bash -e build-scripts/sed.sh
bash -e build-scripts/tar.sh
bash -e build-scripts/xz.sh
bash -e build-scripts/binutils-pass-2.sh
bash -e build-scripts/gcc-pass-2.sh

echo "Stage 1 complete! Please run Stage 2"
exit 0
