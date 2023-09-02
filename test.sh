#!/bin/sh

disk_list() {
    echo $disk

    disk_list=$(fdisk -l | grep -ie '/dev' | sed -e 's/.*\/dev\/\| .*\|[:0-9]//g' | sort -u)
    echo $disk_list
    #echo "${disk_list[@]}"

    #echo $disk | sed 's/dev//g'

    if echo "${disk_list}" | grep -ie "$(echo $disk | sed 's/\/dev\///g')" -q
    then
        echo y
    else
        echo n
    fi
}

disk_list_new() {
    echo $disk

    if fdisk -l | grep -ie "$disk" -q
    then
        echo y
    else
        echo n
    fi
}

setup() {
    echo $disk

    if fdisk -l | grep -ie "${disk}2" -q
    then
        mount ${disk}2 /mnt
        ls /mnt
        cp /root/share/configure.sh /mnt/root/configure.sh
        umount /mnt
    else
        echo n
    fi
}

#echo 'Disk /dev/vda doesnt' | sed -e 's/.*\/dev\/\| .*//g'

#disk=$(echo $1 | sed 's/\/dev\///g')
disk=$1

setup