#!/bin/sh

check_disk() {
    if fdisk -l | grep -ie "$disk" -q
    then
        echo "Disk $disk found"
    else
        echo "Disk $disk not found!"
        echo "Printing disk list:"
        fdisk -l
        exit 1
    fi
}

set_addr() {
    if [[ "$addr" != "" ]]
    then
        nameserver="192.168.1.1"
        interfaces="$(cat << EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
    address 192.168.1.$addr
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

#check_disk() {
    #disk_list=$(fdisk -l | grep -ie '/dev' | sed -e 's/.*\/dev\/\| .*\|[:0-9]//g' | sort -u)
#
    #if echo "${disk_list}" | grep -ie "$(echo $disk | sed 's/\/dev\///g')" -q
    #then
        #echo "Disk $disk found"
    #else
        #echo "Disk $disk not found!"
        #echo "Printing disk list:"
        #fdisk -l
        #exit 1
    #fi
#}

setup() {
    echo $disk

    if fdisk -l | grep -ie "${disk}2" -q
    then
        mount ${disk}2 /mnt
        ls /mnt
        cp /root/share/configure.sh /mnt/root/configure.sh
        cp /root/share/sync.sh /mnt/root/sync.sh
        umount /mnt
    else
        echo n
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
            echo "Help:"
            echo '-a -- provide last part of IP address 192.168.1.122.* -- default is dhcp'
            echo '-d -- provide which disk device is used -- default is /dev/vda'
            echo '-h -- provide hostname'
            exit 1
            ;;
        
    esac
done

if [[ "$host" == "" ]]
then
    echo "No hostname provided!"
    exit 1
fi

check_disk

setup-keymap pl pl

setup-hostname -n $host

set_addr
0
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

yes | setup-disk -m sys -s 0 $disk

setup
