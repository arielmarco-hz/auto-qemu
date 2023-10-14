#!/bin/bash -e

sudo cp runmore /etc/initramfs-tools/scripts/local-premount/runmore
sudo cp somemore /etc/initramfs-tools/hooks/somemore

# Use a better busybox
sudo cp /usr/share/initramfs-tools/hooks/zz-busybox-initramfs /etc/initramfs-tools/hooks/zzz-use-full-busybox 
sudo sed -i 's|/usr/lib/initramfs-tools/bin/busybox|/bin/busybox|' /etc/initramfs-tools/hooks/zzz-use-full-busybox

add="source $(dirname "$(realpath $0)")/qemu.sh"
if ! grep -wq "$add" ~/.bashrc; then
    echo "$add" >> ~/.bashrc
fi
