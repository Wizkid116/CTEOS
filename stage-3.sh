#!/bin/bash
source /install-scripts/variables #copy network and domain names that were defined
#at the beginning, also hostname

#make the rest of the LFS directories
mkdir -pv /{boot,home,mnt,opt,srv}
mkdir -pv /etc/{opt,sysconfig}
mkdir -pv /lib/firmware
mkdir -pv /media/{floppy,cdrom}
mkdir -pv /usr/{,local/}{include,src}
mkdir -pv /usr/local/{bin,lib,sbin}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}
ln -sfv /run /var/run
ln -sfv /run/lock /var/lock
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp

#create essential files
ln -sv /proc/self/mounts /etc/mtab
cat > /etc/hosts << EOF
127.0.0.1 localhost $(hostname)
::1 localhost
EOF

cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/usr/bin/false
daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
EOF

cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
kvm:x:61:
uuidd:x:80:
wheel:x:97:
users:x:999:
nogroup:x:65534:
EOF

echo "tester:x:101:101::/home/tester:/bin/bash" >> /etc/passwd
echo "tester:x:101:" >> /etc/group
install -o tester -d /home/tester
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664 /var/log/lastlog
chmod -v 600 /var/log/btmp

#compile stuff
bash -e /install-scripts/gettext.sh
bash -e /install-scripts/bison.sh
bash -e /install-scripts/perl.sh
bash -e /install-scripts/python.sh
bash -e /install-scripts/texinfo.sh
bash -e /install-scripts/util-linux.sh

#clean up some unneeded files
rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools

#compile more stuff
bash -e /install-scripts/man-pages.sh
bash -e /install-scripts/iana-etc.sh
bash -e /install-scripts/glibc-pass-2.sh
bash -e /install-scripts/zlib.sh
bash -e /install-scripts/bzip2.sh
bash -e /install-scripts/xz-pass-2.sh
bash -e /install-scripts/zstd.sh
bash -e /install-scripts/file-pass-2.sh
bash -e /install-scripts/readline.sh
bash -e /install-scripts/m4-pass-2.sh
bash -e /install-scripts/bc.sh
bash -e /install-scripts/flex.sh
bash -e /install-scripts/tcl.sh
bash -e /install-scripts/expect.sh
bash -e /install-scripts/dejagnu.sh #i've just been to this place before
bash -e /install-scripts/pkgconf.sh
bash -e /install-scripts/binutils-pass-3.sh
bash -e /install-scripts/gmp.sh
bash -e /install-scripts/mpfr.sh
bash -e /install-scripts/mpc.sh
bash -e /install-scripts/attr.sh
bash -e /install-scripts/acl.sh
bash -e /install-scripts/libcap.sh
bash -e /install-scripts/libxcrypt.sh
bash -e /install-scripts/shadow.sh
bash -e /install-scripts/gcc-pass-3.sh #expect this to take the longest
bash -e /install-scripts/ncurses-pass-2.sh
bash -e /install-scripts/sed-pass-2.sh
bash -e /install-scripts/psmisc.sh
bash -e /install-scripts/gettext-pass-2.sh
bash -e /install-scripts/bison.sh
bash -e /install-scripts/grep-pass-2.sh
bash -e /install-scripts/bash-pass-2.sh
bash -e /install-scripts/libtool.sh
bash -e /install-scripts/gdbm.sh
bash -e /install-scripts/gperf.sh
bash -e /install-scripts/expat.sh
bash -e /install-scripts/inetutils.sh
bash -e /install-scripts/less.sh
bash -e /install-scripts/perl.sh
bash -e /install-scripts/xml-parser.sh
bash -e /install-scripts/intltool.sh
bash -e /install-scripts/autoconf.sh
bash -e /install-scripts/automake.sh
bash -e /install-scripts/openssl.sh
bash -e /install-scripts/kmod.sh
bash -e /install-scripts/libelf.sh
bash -e /install-scripts/libffi.sh
bash -e /install-scripts/python-pass-2.sh
bash -e /install-scripts/flit-core.sh
bash -e /install-scripts/wheel.sh
bash -e /install-scripts/setuptools.sh
bash -e /install-scripts/ninja.sh
bash -e /install-scripts/meson.sh
bash -e /install-scripts/coreutils-pass-2.sh
bash -e /install-scripts/check.sh
bash -e /install-scripts/diffutils-pass-2.sh
bash -e /install-scripts/gawk-pass-2.sh
bash -e /install-scripts/findutils-pass-2.sh
bash -e /install-scripts/groff.sh
bash -e /install-scripts/grub.sh # add option for UEFI
bash -e /install-scripts/gzip-pass-2.sh
bash -e /install-scripts/iproute.sh
bash -e /install-scripts/kbd.sh
bash -e /install-scripts/libpipeline.sh
bash -e /install-scripts/make-pass-2.sh
bash -e /install-scripts/patch-pass-2.sh
bash -e /install-scripts/tar-pass-2.sh
bash -e /install-scripts/texinfo.sh
bash -e /install-scripts/vim.sh
bash -e /install-scripts/markupsafe.sh
bash -e /install-scripts/jinja.sh
bash -e /install-scripts/systemd.sh
bash -e /install-scripts/d-bus.sh
bash -e /install-scripts/man-db.sh
bash -e /install-scripts/procps-ng.sh
bash -e /install-scripts/util-linux.sh
bash -e /install-scripts/e2fsprogs.sh
# it was about here where I realized I was following the sysvinit version of the lfs
# book. Which means I have to go back and double check if everything's following the
# systemd version of the handbook. fuuuuuuuuuuuuuuuuuuuuuck

bash -e /install-scripts/strip.sh #chapter 8.82

#clean up files from tests
rm -rf /tmp/*
find /usr/lib /usr/libexec -name \*.la -delete
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf
userdel -r tester

#mask udev's link file & setup dhcp
ln -s /dev/null /etc/systemd/network/99-default.link
#still need to ask the user for the device's name at the beginning
cat > /etc/systemd/network/10-eth-dhcp.network << "EOF"
[Match]
Name=eth0
[Network]
DHCP=ipv4
[DHCPv4]
UseDomains=true
EOF

cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf
domain 1.1.1.1
nameserver 1.1.1.1
nameserver 1.0.0.1
# End /etc/resolv.conf
EOF
#echo $HOSTNAME > /etc/hostname
echo "lfs" > /etc/hostname

#need to come back to this block as well
cat > /etc/hosts << "EOF"
# Begin /etc/hosts
<192.168.0.2> <FQDN> [alias1] [alias2] ...
::1 ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
# End /etc/hosts
EOF

#come back to 9.4.1

cat > /etc/adjtime << "EOF"
0.0 0 0.0
0
LOCAL
EOF

#set timezone and font
timedatectl set-local-rtc 1
echo FONT=Lat2-Terminus16 > /etc/vconsole.conf

#come back here as well
cat > /etc/locale.conf << "EOF"
LANG=en_US-UTF-8
EOF

#set up /etc/profile
cat > /etc/profile << "EOF"
# Begin /etc/profile
for i in $(locale); do
unset ${i%=*}
done
if [[ "$TERM" = linux ]]; then
export LANG=C.UTF-8
else
source /etc/locale.conf
for i in $(locale); do
key=${i%=*}
if [[ -v $key ]]; then
export $key
fi
done
fi
# End /etc/profile
EOF

#set locale
localectl set-locale LANG="en_US.UTF-8" LC_CTYPE="en_US"

#set up inputrc
cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>
# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off
# Enable 8-bit input
set meta-flag On
set input-meta On
# Turns off 8th bit stripping
set convert-meta Off
# Keep the 8th bit for display
set output-meta On
# none, visible or audible
set bell-style none
# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word
# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert
# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line
# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line
# End /etc/inputrc
EOF

#set up /etc/shells
cat > /etc/shells << "EOF"
# Begin /etc/shells
/bin/sh
/bin/bash
# End /etc/shells
EOF

#come back to this as well
cat > /etc/fstab << "EOF"
# Begin /etc/fstab
# file system mount-point type options dump fsck
# order
$LFS   / ext4 defaults 1 1
$SWAP_PATH swap swap pri=1 0 0
# End /etc/fstab
EOF

bash -e /install-scripts/linux.sh

#install grub
grub-install $DRIVE
cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5
insmod part_gpt
insmod ext2
set root=(hd0,2)
menuentry "GNU/Linux, Linux 6.7.4-lfs-12.1-systemd" {
linux /boot/vmlinuz-6.7.4-lfs-12.1-systemd root=/dev/sda2 ro
}
EOF

echo 12.1-systemd > /etc/lfs-release

cat > /etc/lsb-release << "EOF"
DISTRIB_ID="CTE-OS"
DISTRIB_RELEASE="0.1"
DISTRIB_CODENAME="cteos"
DISTRIB_DESCRIPTION="cte operating system based on LFS"
EOF

cat > /etc/os-release << "EOF"
NAME="CTE-OS"
VERSION="0.1"
ID=lfs
VERSION_CODENAME="0.1"
HOME_URL="https://www.linuxfromscratch.org/lfs/"
EOF

exit 0
