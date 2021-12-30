#!/bin/bash

logger(){
    echo -e $1 $2 $3
}

osName=$(((egrep '^(NAME)=' /etc/os-release) | awk -F = {'print $2'}) | tr -d \")
fedoraRelease=$(cat /etc/os-release | grep "VERSION_ID=")
fedoraId=$(rpm -E %fedora)

# Limpiar consola
echo $(clear)

# Mostrar información del Script
logger "Arte a Programar"
logger "Script para instalar RPM Fusion free/nonfree y Codecs"
logger "Disponible solo para Fedora"
logger "v0.1\n"
logger "OS : " $osName $fedoraId

# Comprobación de OS
if [[ $osName = "Fedora Linux" ]]; then
    # Realizar actualización del Sistema
    logger "Para ejecutar este script se requiere acceso administrativo"
    logger "Realizando actualización del sistema"
    sudo dnf -y update

    # Instalación de Repositorio RPM Fusion Free
    logger "\n\nConsulte la documentación oficial"
    logger "https://docs.fedoraproject.org/en-US/quick-docs/setup_rpmfusion/"
    logger "\n\nInstalación de Repositorio RPM Fusion Free"
    sudo dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

    # Instalación de Repositorio RPM Fusion NonFree
    logger "\n\nInstalación de Repositorio RPM Fusion NonFree"
    sudo dnf -y install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    # Installing plugins for playing movies and music
    logger "\n\nInstalación de complementos para reproducir películas y música"
    sudo dnf -y install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
    sudo dnf -y install lame\* --exclude=lame-devel
    sudo dnf -y group upgrade --with-optional Multimedia

    # Instalación de VLC
    logger "\n\nInstalación de VLC"
    sudo dnf -y install vlc

    # Finalizar
    logger "\n\nSe instalado Codecs de Música, Video y Repositorio RPMFusion"        
else
    logger "Tu sistema operativo no es compatible por ahora"  
fi