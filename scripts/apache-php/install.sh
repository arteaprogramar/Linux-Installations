#!/bin/bash

# Mensaje de inicio
echo $(clear)
echo -e "Bash Shell para instalar Apache Server &  PHP 7.x en Fedora"

# Obtener version de Fedora
fedoraVersionId=$(cat /etc/*-release | grep "VERSION_ID=")
fedoraId=$(echo $fedoraVersionId | awk -F = {'print $2'})
echo -e "Version de Fedora: ${fedoraId}"

# Realizar actualización del sistema
echo -e "\nLog: Realizando actualización del sistema"
sudo dnf -y upgrade

# Instalación de Repositorio REMI
echo -e "\nLog: Descarga e Instalación de REMI Repository"
rpmRepository="http://rpms.remirepo.net/fedora/remi-release-$fedoraId.rpm"
echo -e "\nLog: $ dnf -y $rpmRepository"
echo -e $(wget "$rpmRepository" -O remi.rpm && sudo dnf -y install remi.rpm)
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2017
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2018
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2019
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi2020
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi-"$fedoraId"


# Instalación de Plugins para DNF
echo -e "\nLog: Instalación de Plugins para DNF"
sudo dnf -y install dnf-plugins-core

# Habilitar Remi Repository
sudo dnf config-manager --set-enabled remi

# Buscar PHP Remi disponibles
phpAvailables=($((dnf search php*-php | grep "PHP scripting language") | awk -F - {'print $1'}))

# Mostrar al usuario versiones de PHP Disponibles
echo "Ingrese el número de versión de PHP que desea instalar:"
counter=0
for str in "${phpAvailables[@]}"
do :
    echo -e "Para instalar ${str} ingresa : ${counter}"
    ((counter++))
done 

phpVersionInstall=""
while [[ ! $phpVersionInstall =~ ^[0-9]{1,2} ]]; do
    read -p "¿Que versión de PHP deseas instalar? : " phpVersionInstall
    
    if [ $phpVersionInstall -ge $counter ]; then
        phpVersionInstall=""
    else
        php="${phpAvailables[$phpVersionInstall]}"
        echo -e "\nLog: Instalación de $php"
        sudo dnf --enablerepo=remi install "$php" httpd "$php"-php-common
        sudo dnf --enablerepo=remi install "$php"-php-intl "$php"-php-cli "$php"-php-fpm "$php"-php-mysqlnd "$php"-php-zip "$php"-php-devel "$php"-php-gd "$php"-php-mcrypt "$php"-php-mbstring "$php"-php-curl "$php"-php-xml "$php"-php-pear "$php"-php-bcmath "$php"-php-json
        echo $("$php" -v)
        echo -e "\nLog: Comenzar el proceso de Apache Server"
        sudo systemctl start httpd.service
        echo -e "\nLog: Configuración de Firewall"
        sudo firewall-cmd --get-active-zones
    sudo firewall-cmd --permanent --zone=public --add-service=http
    sudo systemctl restart firewalld.service
    sudo systemctl reload firewalld
    fi
done

echo -e "\nEl proceso ha terminado"
echo "Abrir localhost: http://127.0.0.1"
