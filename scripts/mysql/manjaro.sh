#!/bin/bash

logger(){
    echo -e $1 $2 $3
}

osName=$((egrep '^(ID)=' /etc/os-release) | awk -F = {'print $2'})

# Limpiar consola
echo $(clear)

# Mostrar informacion del Script
logger "Arte a Programar"
logger "Script para instalar MySQL Server 5.7"
logger "v0.1"
logger "OS : " $osName

# Actualización del sistema
logger "\n\nActualizando sistema"
sudo pacman -Syu

# Crear carpeta tpm
logger "\n\nCrear carptera Temporal"
tmpDir="tpm"
mkdir $tmpDir
cd $tmpDir
mysqlVersion="mysql-5.7.36-linux-glibc2.12-x86_64"
mysqlPathLinux="export MYSQL_HOME=/usr/local/mysql \n export PATH=${MYSQL_HOME}/bin:${PATH}"

# Comprobar si makepkg esta instado
logger "\n\nComprobar si makepkg esta instado"
{
    makepkg --version
} || {
    # Instalación de Base-Devel
    logger "\n\nConfirma la instalación de base-devel con un *enter*"
    logger "Para instalar todos los paquetes"
    sudo pacman -Sy base-devel
}

# Instalación o comprobación de YAY
logger "\n\nInstalación o comprobación de YAY"
{
    yay --version
} || {
    # Descarga de YAY Helper
    logger "\n\nDescarga de YAY Helper"
    git clone https://aur.archlinux.org/yay.git
    cd yay
    
    # Instalación de YAY Helper
    logger "\n\nInstalación de YAY Helper"
    logger "Confirma la instalación de paquetes adicionales"
    ls -l
    logger "\n\n"
    makepkg -si
}

# Instalación de paquetes adicionales
logger "\n\nInstalación de paquetes adicionales (libaio)"
sudo pacman -S libaio

logger "\n\nInstalación de paquetes adicionales (numactl)"
sudo pacman -S numactl

logger "\n\nInstalación de paquetes adicionales (ncurses5-compat-libs)"
yay -S ncurses5-compat-libs

# Crear un usuario y un grupo mysql
logger "\n\nCrear un usuario y un grupo MySQL"
sudo groupadd mysql
sudo useradd -r -g mysql -s /bin/false mysql

# Descargar la última versión de MySQL Server 5.7
logger "\n\nDescargar la última versión de MySQL Server 5.7"
wget https://dev.mysql.com/get/Downloads/MySQL-5.7/"$mysqlVersion".tar.gz

# Descomprimir archivo descargado
logger "\n\nDescomprimir archivo descargado"
tar zxvf "$mysqlVersion".tar.gz

# Copiar MySQL Server a /usr/local
logger "\n\nCopiar MySQL Server a /usr/local"
sudo mv "$mysqlVersion" /usr/local/"$mysqlVersion"

# Crear un enlace de la carpeta original
logger "\n\nCrear un enlace de la carpeta original"
cd /usr/local 
sudo ln -s "$mysqlVersion" mysql

# Acceder a la carpeta enlace de MySQL
logger "\n\nAcceder a la carpeta enlace de MySQL"
cd mysql

# Configuración de permisos y usuarios de MySQL
logger "\n\nConfiguración de permisos y usuarios de MySQL"
sudo mkdir mysql-files
sudo chown mysql:mysql mysql-files
sudo chmod 750 mysql-files

# Iniciar MySQL
logger "\n\nInicializar MySQL para obtener contraseña temporal"
sudo bin/mysqld --initialize --user=mysql
sudo bin/mysql_ssl_rsa_setup
sudo bin/mysqld_safe --user=mysql &

# Conocer el estado del Servicio de MySQL Server
logger "\n\nConocer el estado del Servicio de MySQL Server"
sudo support-files/mysql.server start
sudo support-files/mysql.server status

# Configuración básica de seguridad de MySQL Server
logger "\n\nConfiguración básica de seguridad de MySQL Server"
sudo bin/mysql_secure_installation

# Agregar MySQL Server al PATH de Linux
sudo cp support-files/mysql.server bin/mysql.server
sudo echo $mysqlPathLinux > /etc/profile.d/mysql.sh
sudo chmod +x /etc/profile.d/mysql.sh

# Nota
logger "\n\nEjecute los siguientes comandos en usuario root para agregar MySQL al path"
logger "$ su"
logger "$ export mysqlPathLinux=\"export MYSQL_HOME=/usr/local/mysql \nexport PATH=\${MYSQL_HOME}/bin:\${PATH}\""
logger "$ echo \$mysqlPathLinux > /etc/profile.d/mysql.sh"
logger "$ source /etc/profile.d/mysql.sh"

# Comprobar estado de MySQL Server
logger "\n\n Ejecuta el siguiente comando para conocer el estado de MySQL"
logger "despues de agregador al PATH de Linux"
logger "$ mysql.server status"
sudo support-files/mysql.server status

# Instalar MySQL Workbench
sudo pacman -Sy mysql-workbench

# Nota
logger "\n\nEjecute el siguiente comando en usuario root para agregar MySQL al path"
logger "$ su"
logger "$ source /etc/profile.d/mysql.sh"
logger "\n\nSe ha instalado correctamente MySQL Server 5.7 & Workbench"

# Borrar archivos temporales
rm -rf $tmpDir