#!/bin/bash

source $(dirname "$0")/../../utils/os.sh
source $(dirname "$0")/../../utils/file.sh
source $(dirname "$0")/../../utils/text.sh

# Script info
info "Instalación de Sublime Text 4 Stable" "1.0"
loggerBold "*Este script ha sido probado en ArchLinux/EndeavourOS/Manjaro*"

# Realizar actualización del sistema
loggerBold "\n\nRealizar actualización del sistema"
sudo pacman -Syuu --noconfirm

# Comprobación de curl
loggerBold "\n\nComprobación de curl"
{
    curl --version
} || {
    loggerBold "\n\nRequiere CURL este script"
    exit
}

# Instalación de GPG Key para SublimeText
loggerBold "\n\nInstalación de GPG Key para SublimeText"
curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg

# Instalación de SublimeText Stable
loggerBold "\n\nInstalación de SublimeText Stable"
architecture=$(uname -m)

if [[ $architecture == "x86_64" ]]; then
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
elif [[ $architecture == "aarch64" ]]; then
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/aarch64" | sudo tee -a /etc/pacman.conf
else
    loggerBold "\n\nTu arquitectura no es compatible con SublimeText"
    exit 
fi

sudo pacman -S sublime-text --noconfirm