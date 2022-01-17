#!/bin/bash

source $(dirname "$0")/../../utils/os.sh
source $(dirname "$0")/../../utils/file.sh
source $(dirname "$0")/../../utils/text.sh

info "Instalación de Android Platform Tools" "1.0"
loggerBold "*Este script ha sido probado en EndeavourOS/Manjaro*"

# Comprobar si script se esta ejecutando como usuario root
if [[ $(getUser) != "root" ]]; then
    userRootRequired
    exit
fi

# Crear folder temporal
loggerBold "\n\nCrear directorio temporal"
createTemp
movetoTemp

# Variables
configPath="export ADB_HOME=/opt/android \nexport PATH=\${ADB_HOME}/platform-tools:\${PATH}"

# Descargar última version de Platform-Tools
loggerBold "\n\nDescargar última version de Platform-Tools para GNULinux"  

{
    wget --version
} || {
    # Require instalar wget
    loggerBold "\n\n*Gradle.sh* requiere del paquete wget"
    logger "Por favor instale *wget* en su GNULinux"
    exit
}

wget https://dl.google.com/android/repository/platform-tools-latest-linux.zip

# Descomprimir archivo
loggerBold "\n\nDescomprimir Platform Tools"
unzip platform-tools-latest-linux.zip

# Mover a ruta /opt/
loggerBold "\n\nMover *platform-tool* a ruta /opt/"
mkdir /opt/android
mv platform-tools /opt/android/platform-tools

# Agregar Platform-Tools a PATH Linux
loggerBold "\n\nAgregar Platform-Tools a PATH Linux"
echo -e $configPath > /etc/profile.d/adb.sh
chmod +x /etc/profile.d/adb.sh
{
    source /etc/profile.d/adb.sh
} || {
    logger "Error al ejecutar el comando *source*"
    logger "Nota: "
    logger "Terminado el script ejecute manualmente el siguiente comando en modo *root*"
    logger "$ source /etc/profile.d/adb.sh"
}

# Obtener información de Platform-Tool
loggerBold "\n\nObtener información de Platform-Tool"
{
    logger "adb --version"
    adb --version
} || {
    logger "./adb --version"
    ./adb --version
}

logger "\nEn algunas distribuciones requiere reiniciar el sistema"

# Remove temp
deleteTemp