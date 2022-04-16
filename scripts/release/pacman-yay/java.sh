#!/bin/bash

source $(dirname "$0")/../../utils/os.sh
source $(dirname "$0")/../../utils/file.sh
source $(dirname "$0")/../../utils/text.sh

# Script info
info "Instalación de Java (OpenJRE-OpenJDK)" "1.0"
loggerBold "*Este script ha sido probado en ArchLinux/EndeavourOS/Manjaro*"

# Documentacion
documentation "Wiki Arch" "https://wiki.archlinux.org/title/java"

# Realizar actualización del sistema
loggerBold "\nRealizar actualización del sistema"
sudo pacman -Syyu --noconfirm

# Buscar versiones de Java Disponibles
loggerBold "\nBuscar versiones disponibles de Java open-(jre/jdk)"
search=$(pacman -Ss jre | egrep 'jre[0-9]{0,2}-openjdk[[:space:]]' | awk -F 'openjdk ' {'print $2'} | awk -F '.' {'print $1'})
declare -a versions=($search)

# Mostrar menu de versiones disponibles de Java
loggerBold "\nMenú de versiones disponibles de Java"
logger "Ingrese un número según la versión de Java que desea instalar:"
counter=0

for i in "${versions[@]}"; do
    logger "Para instalar Java \033[1m$i\033[0m ingrese : \033[1m$counter\033[0m"
    ((counter++))
done

# Instalación de Java
versionToInstall=""
while [[ ! $versionToInstall =~ ^[0-9]{1,2} ]]; do
    read -p "¿Que versión de Java open-(jre/jdk) deseas instalar? : " versionToInstall
    
    if [[ ! $versionToInstall =~ ^[0-9]{1,2} ]]; then
        versionToInstall=""
    elif [ $versionToInstall -ge $counter ]; then
        versionToInstall=""
    else
        # Instalación de Java OpenJRE/JDK
        loggerBold "\n\nInstalación de Java open-(jre/jdk)"
        java=$(echo "${versions[$versionToInstall]}")
        sudo pacman -Sy jre"$java"-openjdk-headless jre"$java"-openjdk jdk"$java"-openjdk openjdk"$java"-doc openjdk"$java"-src

        # Comprobar versión de Java
        loggerBold "\n\nComprobar versión de Java"
        {
            java --version
        } || {  
            java -version
        }
    fi
done