#!/bin/bash

logger(){
    echo -e $1 $2 $3
}

osName=$(((egrep '^(NAME)=' /etc/os-release) | awk -F = {'print $2'}) | tr -d \")

if [[ $osName = "Fedora Linux" ]]; then
    osNumber=$(rpm -E %fedora)
elif [[ $osName = "CentOS Stream" ]]; then
    osNumber=$(rpm -E %centos)
fi


# Limpiar consola
echo $(clear)

# Mostrar información del Script
logger "Arte a Programar"
logger "Script para instalar RPM Fusion free/nonfree y Codecs"
logger "v0.1\n"
logger "OS : " $osName $osNumber


# Realizar actualización del Sistema
logger "Para ejecutar este script se requiere acceso administrativo"
logger "Realizando actualización del sistema"
sudo dnf -y update

# Comprobación de OS
if [[ $osName = "Fedora Linux" ]]; then
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
    logger "\n\nSe ha instalado Codecs de Música, Video y Repositorio RPMFusion"        
elif [[ $osName = "CentOS Stream" ]]; then
    if [[ $osNumber = "9" ]]; then 
        # Nota:  CentOS Stream 9
        logger "\n\nActualmente no existe soporte de RPMFusion para CentOS Stream 9"

        # Installing plugins for playing movies and music
        logger "\n\nInstalación de complementos para reproducir películas y música"
        sudo dnf -y install gstreamer1-plugins-{bad-\*,good-\*,base}  --exclude=gstreamer1-plugins-bad-free-devel
        sudo dnf -y install lame\* --exclude=lame-devel
        sudo dnf -y group upgrade --with-optional Multimedia

        # Finalizar
        logger "\n\nSe ha instalado Codecs de Música y Video"      
    fi
else
    logger "Tu sistema operativo no es compatible por ahora"  
fi