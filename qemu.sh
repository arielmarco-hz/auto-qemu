#!/bin/bash

function qemu () {
    kernel=arch/x86_64/boot/bzImage

    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        echo "qemu '<qemu args>' '<boot params>' 'host:guest share:list'"
        return 0
    fi

    local k i m v
    if ! grep -wqe -kernel <<< "$@"; then
        local k="-kernel '$kernel'"
        if ! [ -f "$kernel" ]; then
            echo "Haven't found '$kernel', are you in the right place?"
            return 1
        fi
    fi

    if ! grep -wqe -initrd <<< "$@"; then
        local i='-initrd initrd.img'
    else
        echo "Please don't use your own initrd"
        return 1
    fi

    if ! grep -wqe -m <<< "$@"; then
        local m='-m 4G'
    fi
    
    sed -i "/.*mount -t 9p host.*/d" runmore.sh
    local -i id=0
    v=
    for j in $3 $PWD:/workdir /:/host; do
        IFS=: read onhost onguest <<< "$j"
        v+="-virtfs local,path=$onhost,mount_tag=host$id,security_model=passthrough,id=host$id "
        if [ -n $onguest ]; then
            local mcmd="mkdir -p $onguest; mount -t 9p host$id $onguest"
            echo "$mcmd" >> runmore.sh
        fi
        id+=1
    done

    if ( [ -f runmore.sh ] &&
       ( ! [ -f runmore.sh.old ] ||
       ! cmp runmore.sh runmore.sh.old ) ) ||
       ( [ -f somemore.sh ] &&
       ( ! [ -f somemore.sh.old ] ||
       ! cmp somemore.sh somemore.sh.old ) ); then
       echo "Regenrating initramfs"
       mkinitramfs -o initrd.img
       cp somemore.sh{,.old} 
       cp runmore.sh{,.old} 
    fi
       
    set -x
    qemu-system-x86_64 -nographic $v $m $k $i $1 -append "console=ttyS0 $2"
    set +x
    tset
}
