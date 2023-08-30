#!/bin/sh

set_addr() {
    if [[ "$addr" != "" ]]
    then
        nameserver="192.168.122.1"
        interfaces="$(cat << EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.122.$addr
    gateway $nameserver
    hostname $host
EOF
        )"

        echo "$interfaces" | setup-interfaces -i

        /etc/init.d/networking --quiet start &

        echo '' | setup-dns -n $nameserver
    else
        setup-interfaces -a

        /etc/init.d/networking --quiet start &

        $(echo ''; echo '') | setup-dns
    fi

}

addr=''
disk='/dev/vda'
host=''

while getopts "a:d:h:" opt
do
    case $opt in
        a)
            addr=$OPTARG
            ;;
        
        d)
            disk=$OPTARG
            ;;
        
        h)
            host=$OPTARG
            ;;
        
        *)
            echo "Command not recognized"
            ;;
        
    esac
done

if [[ "$host" == "" ]]
then
    echo "No hostname provided!"
    exit 1
fi

setup-keymap pl pl

setup-hostname -n $host

set_addr

echo root:kacpi | chpasswd

setup-timezone -z UTC

/etc/init.d/hostname --quiet restart

rc-update --quiet add networking boot
rc-update --quiet add seedrng boot || rc-update --quiet add urandom boot
rc-update --quiet add acpid default
rc-update --quiet add crond default
openrc boot
openrc default

cat << EOF > /etc/hosts
127.0.0.1   $host localhost
::1         localhost
EOF

setup-proxy none

setup-apkrepos -1

setup-sshd -c openssh
setup-ntp -c chrony

echo 'y' | setup-disk -m sys -s 0 $disk