#!/bin/sh

ssh_keys() {
    ssh_dir="/home/kacper/.ssh"
    ssh_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8b+eFu69yUr5bcwPWA/ci+oUWKiXMZWqtOATWUI+Qua7aIKBU2evIdeEdq8bm9jJGjIidwTvGJLtcwesXgqIDgROlCW9h6aXXBFRGoDlvHebryTmKqMIBga+cdYVqwXj8tmYlwP0QxUevTXkmmKTkQI8joDPooj2Eol6DkYV0hRASoXeTa++HdUyN9Jwi6a+XVhvWMePQbuVkKofFxSauOkxI0zrbUUQGfWo+AbxfDNKHKb/6NgOPmmvvVOdD+VzMf7K4g7f8lXYh7JBv1sxccWu2LGYboSIT4HTEsxdy6WQWaIe+VXvyEqmZwE1kWgrulpPNkiUx9t93Z5ndwHsxHa8j8oVaPmJ1B5GnmcOX93/fALcmmAw+x95Xdz9No2j3Hw5Yg7dWs/eQEQ6zqJ+aXhl0ckxOS/tPPqRvEcg+9IehexmeMz1Rkaf8wbU2dxvNSP3Gx0sAMbMc487MTvowAtNW3vuwFEsdyixHGizuZxuux2xPXY2EapfTEHEnM20= kacper@arch"

    if $(ls /home/kacper/ -a) -z .ssh
    then
        echo exists
        rm -rf ${ssh_dir}
    else
        echo no
    fi
    #rm -rf /home/kacper/.ssh
    ssh-keygen -b 2048 -t rsa -f ${ssh_dir}/id_rsa -q -N ""

    touch ${ssh_dir}/authorized_keys
    chmod 600 ${ssh_dir}/authorized_keys

    echo ${ssh_key} > ${ssh_dir}/authorized_keys
}

python() {
    sudo apk update
    sudo apk add python3 py3-pip

    if ! test -f "/usr/bin/python"
    then
        sudo ln $(which python3) /usr/bin/python
    fi
}

ssh_keys
python