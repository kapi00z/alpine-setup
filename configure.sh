#!/bin/sh

sed -i 's/\#http/http/g' /etc/apk/repositories

apk update
apk add vim sudo

adduser -D kacper
echo "kacper:kacpi" | chpasswd

echo 'kacper ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/kacper