#!/bin/bash 

cd $LFS/sources
tar xvf findutils-4.9.0.tar.xz
cd findutils-4.9.0

./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)
make

make DESTDIR=$LFS install

cd ..

rm -rf findutils-4.9.0
