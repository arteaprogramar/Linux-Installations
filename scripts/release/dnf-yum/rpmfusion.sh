#!/bin/bash

source $(dirname "$0")/../../utils/os.sh
source $(dirname "$0")/../../utils/file.sh
source $(dirname "$0")/../../utils/text.sh

info "Instalación de RPMFusion and Codecs" "1.0"

# Variables
osName=$(getNameOs)
osNumber=$(getVersionOs)

# Realizar actualización del Sistema
loggerBold "Para ejecutar este script se requiere acceso administrativo"
loggerBold "Realizando actualización del sistema"
sudo dnf -y update

# Comprobación de OS
loggerBold "\n\nCompatibilidad de Script"
{
    rpm --version
} || {
    loggerBold "Tu sistema operativo no es compatible con RPM"  
    exit
}

# Instalación de Repositorio RPM Fusion
if [[ $osName == "Fedora Linux" ]]; then
    # Instalación de Repositorio RPM Fusion Free
    loggerBold "\n\nConsulte la documentación oficial"
    logger "https://docs.fedoraproject.org/en-US/quick-docs/setup_rpmfusion/"
    loggerBold "\n\nInstalación de Repositorio RPM Fusion Free"
    sudo dnf -y localinstall https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$osNumber".noarch.rpm

    # Instalación de Repositorio RPM Fusion NonFree
    loggerBold "\n\nInstalación de Repositorio RPM Fusion NonFree"
    sudo dnf -y localinstall https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$osNumber".noarch.rpm

    # Installing plugins for playing movies and music
    loggerBold "\n\nInstalación de complementos para reproducir películas y música"
    sudo dnf -y install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
    sudo dnf -y install lame\* --exclude=lame-devel
    sudo dnf -y group upgrade --with-optional Multimedia

    # Instalación de VLC
    loggerBold "\n\nInstalación de VLC"
    sudo dnf -y install vlc

    # Finalizar
    loggerBold "\n\nSe ha instalado Codecs de Música, Video y Repositorio RPMFusion"        
else
    if [[ $osName == "CentOS Stream" ]]; then
        if [[ $osNumber == "9" ]]; then
            # Nota:  CentOS Stream 9
            loggerBold "\n\nActualmente no existe soporte de RPMFusion para CentOS Stream 9"
        fi
    fi

    sudo dnf -y localinstall --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-"$osNumber".noarch.rpm
    sudo dnf -y localinstall --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-"$osNumber".noarch.rpm 
    sudo dnf -y localinstall https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-"$osNumber".noarch.rpm

    if [[ $osName == "CentOS Stream" ]]; then
        if [[ $osNumber -ge 8 ]]; then
            sudo dnf config-manager --enable powertools
        fi
    else
        sudo dnf config-manager --enable PowerTools
    fi

    if [[ $osName == "Red Hat Enterprise Linux" ]]; then
        if [[ $osNumber -ge 8 ]]; then
            sudo subscription-manager repos --enable "codeready-builder-for-rhel-8-$(uname -m)-rpms"
        else
            subscription-manager repos --enable "rhel-*-optional-rpms" --enable "rhel-*-extras-rpms"
        fi
    fi

    # Installing plugins for playing movies and music
    loggerBold "\n\nInstalación de complementos para reproducir películas y música"
    sudo dnf -y install gstreamer1-plugins-{bad-\*,good-\*,base} --exclude=gstreamer1-plugins-bad-free-devel
    sudo dnf -y install lame\* --exclude=lame-devel
    sudo dnf -y group upgrade --with-optional Multimedia
    
    # Instalación de VLC
    loggerBold "\n\nInstalación de VLC"
    sudo dnf -y install vlc

    # Finalizar
    loggerBold "\n\nSe ha instalado Codecs de Música, Video y Repositorio RPMFusion"
fi