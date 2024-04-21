#!/bin/bash 

cd $LFS/sources
tar xvf tar-1.35.tar.xz
cd tar-1.35

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess)

make

make DESTDIR=$LFS install

cd ..
rm -rf tar-1.35
