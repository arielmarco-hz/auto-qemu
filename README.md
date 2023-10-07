# Qemu Shorts

A function that chooses default arguments for qemu with easy support for shared folders

To do the magic, the install.sh creates an initramfs hook to add things to the image created
by mkinitramfs, and an initramfs script that will get run during init of that image.


The `somemore` hook looks for a script named `somemore.sh` in the directory where `qemu` is run and runs
it while creating the image.
The `runmore` hook looks for a script named `runmore.sh` in the that directory and will run it when the
image is run

somemore.sh and runmore.sh files in this repository are example scripts

A function named `qemu` is created with the following syntax:
```bash
    qemu '<qemu args>' '<boot params>' 'host:guest share:list'
```
