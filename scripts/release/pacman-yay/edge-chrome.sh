#!/bin/bash

source $(dirname "$0")/../../utils/os.sh
source $(dirname "$0")/../../utils/file.sh
source $(dirname "$0")/../../utils/text.sh

# Script info
info "Instalación de Google Chrome y Microsoft Edge" "1.0"
loggerBold "*Este script ha sido probado en ArchLinux/EndeavourOS/Manjaro*"

# Realizar actualización del sistema
loggerBold "\nRealizar actualización del sistema"
sudo pacman -Syyu 

# Instalación o comprobación de YAY
loggerBold "\n\nInstalación o comprobación de YAY"

{
    yay --version
} || {
    # Descarga de YAY Helper
    loggerBold "\n\nSe requiere tener instalado YAY (AUR Helper)"
    exit
}

# Instalación de Google Chrome
loggerBold "\n\nInstalación de Google Chrome"
yay -S google-chrome --noconfirm

# Instalación de Microsoft Edge
loggerBold "\n\nInstalación de Google Chrome"
yay -S microsoft-edge-stable-bin --noconfirm
