#!/bin/sh

copy_configure() {
    if ! mount | grep -ie "share" -q
    then
        mkdir -p share
        mount -t virtiofs /share share
    fi
    cp share/configure.sh .
    umount share
}

copy_configure