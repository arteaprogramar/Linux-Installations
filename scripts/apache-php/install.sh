#!/bin/bash

logger() {
    echo -e $1 $2 $3
}

osName=$(((egrep '^(NAME)=' /etc/os-release) | awk -F = {'print $2'}) | tr -d \")
fedoraRelease=$(cat /etc/os-release | grep "VERSION_ID=")
fedoraId=$(rpm -E %fedora)

# Limpiar consola
echo $(clear)

# Mostrar información del Script
logger "Arte a Programar"
logger "Script para instalar Apache Server & PHP 7+"
logger "Disponible solo para Fedora"
logger "v0.3\n"
logger "OS : " $osName $fedoraId

# Comprobación de OS
if [[ $osName = "Fedora Linux" ]]; then
    # Realizar actualización del Sistema
    logger "Para ejecutar este script se requiere acceso administrativo"
    logger "Realizando actualización del sistema"
    sudo dnf -y update

    # Instalación de Repositorio REMI
    logger "\n\nDescarga e Instalación de Repositorio REMI"
    sudo dnf -y install http://rpms.remirepo.net/fedora/remi-release-"$fedoraId".rpm
    sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
    sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2017
    sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2018
    sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2019
    sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2020
    sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi-"$fedoraId"

    # Instalación de Plugins para DNF
    logger "\n\nInstalación de Plugins para DNF"
    sudo dnf -y install dnf-plugins-core

    # Habilitar REMI Repository
    sudo dnf config-manager --set-enabled remi

    # Buscar versiones de PHP disponibles en REMI
    logger "\n\nEl siguiente proceso es un poco tardado"
    logger "Por favor espere un momento"
    logger "\n\nCuando obtenga algo parecido a esto:"
    logger "Importing GPG key 0x478F8947:"
    logger "Ingrese la letra *y* posteriormente de *enter* (Repetir 2veces)"
    logger "Esto debido a que se debe aceptar las GPG llaves de REMI"
    logger "\n\nBuscar versiones de PHP disponibles en REMI"
    phpAvailables=($((dnf search php*-php | grep "PHP scripting language") | awk -F - {'print $1'}))

    # Mostrar al usuario versiones de PHP Disponibles
    logger "\n\nMenú de versiones de PHP Disponibles para instalar"
    logger "Ingrese un número según la versión de PHP que desea instalar:"
    counter=0
    for str in "${phpAvailables[@]}"
    do :
        echo -e "Para instalar ${str} ingrese : ${counter}"
        ((counter++))
    done

    phpVersionInstall=""
    while [[ ! $phpVersionInstall =~ ^[0-9]{1,2} ]]; do
        read -p "¿Que versión de PHP deseas instalar? : " phpVersionInstall
        
        if [ $phpVersionInstall -ge $counter ]; then
            phpVersionInstall=""
        else
            # Almacenar versión a instalar
            php="${phpAvailables[$phpVersionInstall]}"

            # Instalación de Apache Server y PHP
            logger "\n\nDescarga e instalación de $php"
            sudo dnf --enablerepo=remi -y install "$php" httpd "$php"-php-common

            # Instalación de PHP Extensions
            logger "\n\nInstalación de PHP Extensions"
            sudo dnf --enablerepo=remi -y install "$php"-php-intl "$php"-php-cli "$php"-php-fpm "$php"-php-mysqlnd "$php"-php-zip "$php"-php-devel "$php"-php-gd "$php"-php-mcrypt "$php"-php-mbstring "$php"-php-curl "$php"-php-xml "$php"-php-pear "$php"-php-bcmath "$php"-php-json
            
            # Obtener información de PHP instalada
            logger "\n\nObtener información de PHP instalada"
            echo $("$php" -v)

            # Configuración de Apache
            logger "\n\nConfiguración de Apache Server"
            sudo systemctl start httpd.service

            # Configuración de Firewall
            logger "\n\Configuración de Firewall"
            sudo firewall-cmd --get-active-zones
            sudo firewall-cmd --permanent --zone=public --add-service=http
            sudo systemctl restart firewalld.service
            sudo systemctl reload firewalld

            # Cambiar permisos de /var/www/html
            logger "\n\nAgregar todos los permisos (rwx) a /var/www/html"
            sudo chmod 777 /var/www/html

            # Crear archivo index.php en localhost
            logger "Crear archivo index.php en localhost"
            echo "<?php phpinfo(); ?>" > /var/www/html/index.php

            # Finalizar
            logger "\n\nSe instalado Apache Server y PHP correctamente"
            logger "\nAbrir localhost: http://127.0.0.1"
            xdg-open http://127.0.0.1
        fi
    done

else
    logger "Tu sistema operativo no es compatible por ahora"
fi