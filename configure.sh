#!/bin/sh

add_repos() {
    if cat /etc/apk/repositories | grep -ie '#http' -q
    then
        echo "Fixing repositories"
        sed -i 's/\#http/http/g' /etc/apk/repositories

        apk update
        apk add vim
    else
        echo "Repositories prepared!"
    fi
}

add_user() {
    if cat /etc/passwd | grep -ie 'kacper' -q
    then
        echo "User created!"
    else
        echo "Creating user"
        apk add sudo

        adduser -D kacper
        echo "kacper:kacpi" | chpasswd

        echo 'kacper ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/kacper
    fi
}

add_share() {
    su - kacper -c "mkdir -p share"
    su - kacper -c "sudo mount -t virtiofs /share share"
}

advanced_setup() {
    su - kacper -c "sh share/conf.sh"
}

rm_share() {
    su - kacper -c "sudo umount share"
    su - kacper -c "rm -rf share"
}

adv="n"

while getopts "a" opt
do
    case $opt in
        a)
            adv="y"
            ;;
    esac
done

add_repos
add_user

if echo "$adv" -eq "y"
then
    add_share
    advanced_setup
    rm_share
fi