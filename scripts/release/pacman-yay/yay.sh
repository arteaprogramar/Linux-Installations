#!/bin/bash

source $(dirname "$0")/../../utils/os.sh
source $(dirname "$0")/../../utils/file.sh
source $(dirname "$0")/../../utils/text.sh

info "Instalación de YAY (AUR Helper)"
loggerBold "*Este script ha sido probado en ArchLinux/EndeavourOS/Manjaro*"

# Documentacion
documentation "YAY (Github)" "https://github.com/Jguer/yay"
documentation "Wiki Arch" "https://wiki.archlinux.org/title/AUR_helpers"

# Instalación de Base-Devel
loggerBold "\n\nInstalación de Base-Devel"
sudo pacman -Sy base-devel --noconfirm

# Temporal
loggerBold "\n\nCrear directorio temporal"
createTemp
movetoTemp

# Actualización del sistema
loggerBold "\n\nActualización del sistema"
sudo pacman -Syu --noconfirm

# Instalación o comprobación de YAY
loggerBold "\n\nInstalación o comprobación de YAY"

{
    yay --version
} || {
    # Descarga de YAY Helper
    loggerBold "\n\nDescarga de YAY Helper"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    
    # Instalación de YAY Helper
    loggerBold "\n\nInstalación de YAY Helper"
    makepkg -si
}

# Resultado
loggerBold "\n\nSe ha instalado correctamente YAY (AUR Helper)"
yay --version

# Remove temp
deleteTemp