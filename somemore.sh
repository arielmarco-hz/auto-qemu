#!/bin/sh

copy_exec /bin/lsusb /bin

cp -aZ /sbin/insmod "$DESTDIR/sbin/"
