#!/bin/sh

os_id=$(grep '^ID=' /etc/os-release | cut -d'=' -f2)

if [[ $os_id == "debian" || $os_id == "ubuntu" ]]; then
    echo "Estas ejecutando GNU Linux : $os_id"

    # Instrucciones para Debian
    if [ $os_id == "debian" ]; then

        sudo apt install lsb-release apt-transport-https ca-certificates  wget -y
        sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

        # Obtener el nombre base de debian
        codename=$(lsb_release -sc)

        # Validar si se usa Debian Testing con nombre base "trixie"
        if [[ $codename == "trixie" || $codename == "testing" ]]; then
            echo "deb https://packages.sury.org/php/ bookworm main" | sudo tee /etc/apt/sources.list.d/php.list
        else
            echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
        fi

    fi

    # Instrucciones para Ubuntu
    if [ $os_id == "ubuntu" ]; then
        sudo add-apt-repository ppa:ondrej/php
    fi

    # Actualizar repositorios
    sudo apt update

else
    echo "Estas ejecutando GNU Linux : $os_id"
fi
