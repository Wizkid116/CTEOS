#!/bin/bash 
cd $LFS/sources
tar xvf bash-5.2.21.tar.xz
cd bash-5.2.21

./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc

make

make DESTDIR=$LFS install

ln -sv bash $LFS/bin/sh

cd ..
rm -rf bash-5.2.21/

