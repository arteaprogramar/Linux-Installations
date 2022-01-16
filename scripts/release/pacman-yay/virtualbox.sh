#!/bin/bash

source $(dirname "$0")/../../utils/os.sh
source $(dirname "$0")/../../utils/file.sh
source $(dirname "$0")/../../utils/text.sh

info "Instalación de VirtualBox" "1.0"
loggerBold "*Este script ha sido probado en EndeavourOS*"

# Referencias
documentation "Discovery EndeavourOS" "https://discovery.endeavouros.com/applications/how-to-install-virtualbox/"
documentation "Wiki Arch" "https://wiki.archlinux.org/title/VirtualBox"
documentation "Wiki Manjaro" "https://wiki.manjaro.org/index.php/VirtualBox"

# Variables
osName=$(getNameOs)
osVersion=$(getIdOs)

if [[ $osName == "Arch Linux" ]]; then
    # Instalación de kernel headers
    loggerBold "\n\nInstalación de kernel headers"
    logger "¿Que versión del kernel-headers desea instalar?"
    versionToInstall=""
    
    while [[ ! $versionToInstall =~ ^[y-Y|n-N]{1} ]]; do
        read -p "¿Desea instalar Kernel-LTS-Headers? (y|n) : " versionToInstall

        if [[ ! $versionToInstall =~ ^[y-Y|n-N]{1} ]]; then
            versionToInstall=""
        elif [[ $versionToInstall == "y" || $versionToInstall == "Y" ]]; then
            sudo pacman -Sy linux-lts-headers --noconfirm

            # Instalación de VirtualBox
            loggerBold "\n\nInstalación de VirtualBox"
            sudo pacman -Sy virtualbox virtualbox-guest-iso --noconfirm
            sudo pacman -Sy virtualbox-host-dkms  --noconfirm
        else 
            sudo pacman -Sy linux-headers --noconfirm --noconfirm

            # Instalación de VirtualBox
            loggerBold "\n\nInstalación de VirtualBox"
            sudo pacman -Sy virtualbox virtualbox-guest-iso --noconfirm
            sudo pacman -Sy virtualbox-host-modules-arch  --noconfirm
        fi
    done

    # Configuración final de VirtualBox (Módulo y Usuario)
    loggerBold "\n\nConfiguración final de VirtualBox (Módulo y Usuario)"
    sudo modprobe vboxdrv
    sudo gpasswd -a $USER vboxusers

else
    loggerBold "\n\nSu GNULinux no es compatible por ahora con este script"
    exit
fi

 # Finalizar
loggerBold "\n\nSe ha instalado correctamente VirtualBox"
