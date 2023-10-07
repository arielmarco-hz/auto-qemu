#!/bin/bash -e

sudo cp runmore /etc/initramfs-tools/scripts/local-premount/runmore
sudo cp somemore /etc/initramfs-tools/hooks/somemore

add="source $(dirname "$(realpath $0)")/qemu.sh"
if ! grep -wq "$add" ~/.bashrc; then
    echo "$add" >> ~/.bashrc
fi
