#!/bin/bash

logger(){
    echo -e $1 $2 $3
}

osName=$((egrep '^(ID)=' /etc/os-release) | awk -F = {'print $2'})

# Limpiar consola
echo $(clear)

# Mostrar informacion del Script
logger "Arte a Programar"
logger "Script para instalar Android Platform Tools"
logger "v0.1"
logger "OS : " $osName

# Crear carpeta tpm
logger "\n\nCrear carptera Temporal"
tmpDir="tpm"
mkdir $tmpDir
cd $tmpDir
platformToolsPathLinux="export ADB_HOME=/opt/android \n export PATH=\${ADB_HOME}/platform-tools:\${PATH}"

# Comprobar si script se esta ejecutando como usuario root
logger "\n\nComprobar si script se esta ejecutando como usuario root"
username=$(whoami)

if [[ $username = "root" ]]; then
    # Descargar última version de Platform-Tools
    logger "\n\nDescargar última version de Platform-Tools para GNULinux"  
    wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip

    # Descomprimir archivo
    logger "\n\nDescomprimir Platform Tools"
    unzip platform-tools-latest-linux.zip

    # Mover a ruta /opt/
    mkdir /opt/android
    mv platform-tools /opt/android/platform-tools

    # Agregar Platforms-Tools a PATH Linux
    echo -e $platformToolsPathLinux > /etc/profile.d/adb.sh
    chmod +x /etc/profile.d/adb.sh
    source /etc/profile.d/adb.sh

    # Obtener información de Platform-Tool
    logger "\n\nObtener información de Platform-Tool"
    {
        logger "adb --version"
        adb --version
    } || {
        logger "./adb --version"
        ./adb --version
    }
else
    logger "\n\nEjecuta el script como usuario root"
fi

