#!/bin/bash

source $(dirname "$0")/../utils/text.sh
source $(dirname "$0")/../utils/file.sh
source $(dirname "$0")/../utils/os.sh

info "Instalación de Gradle" "1.0"
loggerBold "*Este script ha sido probado en EndeavourOS/Manjaro*"


# Comprobar si Java esta instalado
loggerBold "Comprobar si Java esta instalado"
{
    java --version
} || {
    loggerBold "Gradle Script require Java JDK o OpenJDK"
    loggerBold "Instale el paquete antes mencionado e intente nuevamente"
    exit
}

# Comprobar si script se esta ejecutando como usuario root
if [[ $(getUser) != "root" ]]; then
    userRootRequired
    exit
fi

# Crear folder temporal
loggerBold "\n\nCrear directorio temporal"
createTemp
movetoTemp

# Descargar archivo json
{
    wget --version
} || {
    # Require instalar wget
    loggerBold "\n\n*Gradle.sh* requiere del paquete wget"
    logger "Por favor instale *wget* en su GNULinux"
    exit
}
loggerBold "\n\nDescargar lista de Gradle disponibles"
wget https://raw.githubusercontent.com/gradle/gradle/master/released-versions.json -O g.json

json=$(cat g.json | \
python -c '

import json,sys; 
obj=json.load(sys.stdin); 

for index in obj["finalReleases"]:
    str=index["version"]
    print("\"{}\"".format(str))
')

# Crear array de versiones
declare -a versions=($json)

# Mostrar menu de versiones disponibles de Gradle
loggerBold "\nMenú de versiones disponibles de Gradle"
logger "Ingrese un número según la versión de Gradle que desea instalar:"
counter=0

for i in "${versions[@]}"; do
    logger "Para instalar Gradle \033[1m$i\033[0m ingrese : \033[1m$counter\033[0m"
    ((counter++))

    if [ $counter -ge 20 ]; then
        break
    fi
done

# Instalación de Gradle
versionToInstall=-1
while [[ ! $versionToInstall =~ ^[0-9]{1,2} ]]; do
    read -p "¿Que versión de Gradle deseas instalar? : " versionToInstall

    if [[ ! $versionToInstall =~ ^[0-9]{1,2} ]]; then
        versionToInstall=""
    elif [ $versionToInstall -ge $counter ]; then
        versionToInstall=""
    else
        # Descargar Gradle
        loggerBold "\n\nDescargar Gradle"
        gradle=$(echo "${versions[$versionToInstall]}" | tr -d '"')
        wget https://services.gradle.org/distributions/gradle-"$gradle"-all.zip

        # Instalando y configurando Gradle
        loggerBold "\n\nInstalando y configurando Gradle"
        unzip gradle-"$gradle"-all.zip
        mkdir /opt/Gradle
        mv gradle-"$gradle" /opt/Gradle/gradle-"$gradle"

        # Agregar Gradle al PATH Linux
        loggerBold "\n\nAgregando Gradle al PATH Linux"
        configPath="export GRADLE_HOME=/opt/Gradle/gradle-$gradle \nexport PATH=\${GRADLE_HOME}/bin:\${PATH}"
        echo -e $configPath > /etc/profile.d/gradle.sh
        chmod +x /etc/profile.d/gradle.sh
        source /etc/profile.d/gradle.sh

        # Obtener version de Gradle
        loggerBold "\n\nObtener version de Gradle"
        gradle --version
    fi
done


# Remove temp
deleteTemp