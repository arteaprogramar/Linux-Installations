#!/bin/bash

source $(dirname "$0")/../../utils/os.sh
source $(dirname "$0")/../../utils/file.sh
source $(dirname "$0")/../../utils/text.sh

info "Instalación de MySQL Server 5.7 u 8.+" "1.0"

# Documentacion
documentation "MySQL Dev" "https://dev.mysql.com/doc/refman/5.7/en/binary-installation.html"
documentation "MySQL Dev" "https://dev.mysql.com/doc/refman/8.0/en/binary-installation.html"

# Variables
osName=$(getNameOs)
osNumber=$(getVersionOs)
mysql5="mysql-5.7.37-linux-glibc2.12-x86_64"
mysql8="mysql-8.0.28-linux-glibc2.17-x86_64-minimal"
mysqlVersion=""
configPath="export MYSQL_HOME=/usr/local/mysql \\\\\nexport PATH=\\\${MYSQL_HOME}/bin:\\\${PATH}"

# Crear folder temporal
loggerBold "\n\nCrear directorio temporal"
createTemp
movetoTemp

# Actualización del sistema
loggerBold "\n\nActualizando sistema"
sudo apt -y upgrade

# Instalación de paquetes adicionales
loggerBold "\n\nInstalación de paquetes adicionales (libaio)"
sudo apt -y install libaio1

loggerBold "\n\nInstalación de paquetes adicionales (numactl)"
sudo apt -y install numactl

loggerBold "\n\nInstalación de paquetes adicionales (ncurses5-compat-libs)"
sudo add-apt-repository universe
sudo apt -y install libncurses5 libncurses5:i386

# loggerBold "\n\nInstalación de paquetes adicionales (libcrypt.so.1 legacy)"
# sudo pacman -S libxcrypt-compat --noconfirm

# Versión de MySQL ha instalar
loggerBold "\n\nMenú de versiones disponibles de MySQL Server"
logger "Para instalar \033[1mMySQL 5.7\033[0m ingrese \033[1m0\033[0m"
logger "Para instalar \033[1mMySQL 8.0\033[0m ingrese \033[1m1\033[0m"
versionToInstall=""

while [[ ! versionToInstall =~ ^[0-1]{1} ]]; do
    read -p "¿Que versión de MySQL Server deseas instalar? : " versionToInstall
    
    if [[ ! $versionToInstall =~ ^[0-1]{1} ]]; then
        versionToInstall=""
    elif [ $versionToInstall -ge 2 ]; then
        versionToInstall=""
    else 
        # Descargar la última versión de MySQL Server
        loggerBold "\n\nDescargar la última versión de MySQL Server"
        
        if [[ $versionToInstall == 0 ]]; then
            mysqlVersion="$mysql5"
            wget https://dev.mysql.com/get/Downloads/MySQL-5.7/"$mysqlVersion".tar.gz

            # Descomprimir archivo descargado
            loggerBold "\n\nDescomprimir archivo descargado"
            tar zxvf "$mysqlVersion".tar.gz
        else
            mysqlVersion="$mysql8"
            wget https://dev.mysql.com/get/Downloads/MySQL-8.0/"$mysqlVersion".tar.xz

            # Descomprimir archivo descargado
            loggerBold "\n\nDescomprimir archivo descargado"
            tar -xvf "$mysqlVersion".tar.xz
        fi
        
        break
    fi

done

# Crear un usuario y un grupo mysql
loggerBold "\n\nCrear un usuario y un grupo MySQL"
sudo groupadd mysql
sudo useradd -r -g mysql -s /bin/false mysql

# Copiar MySQL Server a /usr/local
loggerBold "\n\nCopiar MySQL Server a /usr/local"
sudo mv "$mysqlVersion" /usr/local/"$mysqlVersion"

# Crear un enlace de la carpeta original
loggerBold "\n\nCrear un enlace de la carpeta original"
cd /usr/local 
sudo ln -s "$mysqlVersion" mysql

# Acceder a la carpeta enlace de MySQL
loggerBold "\n\nAcceder a la carpeta enlace de MySQL"
cd mysql

# Configuración de permisos y usuarios de MySQL
loggerBold "\n\nConfiguración de permisos y usuarios de MySQL"
sudo mkdir mysql-files
sudo chown mysql:mysql mysql-files
sudo chmod 750 mysql-files

# Iniciar MySQL
loggerBold "\n\nInicializar MySQL para obtener contraseña temporal"
sudo bin/mysqld --initialize --user=mysql
sudo bin/mysql_ssl_rsa_setup
sudo bin/mysqld_safe --user=mysql &

# Conocer el estado del Servicio de MySQL Server
loggerBold "\n\nConocer el estado del Servicio de MySQL Server"
sudo cp support-files/mysql.server bin/mysql.server
sudo support-files/mysql.server start
sudo support-files/mysql.server status

# Configuración básica de seguridad de MySQL Server
loggerBold "\n\nConfiguración básica de seguridad de MySQL Server"
sudo bin/mysql_secure_installation

# Instalar MySQL Workbench
sudo apt -y install mysql-workbench

# Agregar al PATH Linux MySQL Server
loggerBold "\n\nAgregar MySQL al PATH de Linux"
while [[ ! -f /etc/profile.d/mysql.sh ]]; do
    logger "Ingresa tu contraseña correctamente"
    su -c "echo -e $configPath > /etc/profile.d/mysql.sh; chmod +x /etc/profile.d/mysql.sh; source /etc/profile.d/mysql.sh" root
done

# Información de MySQL
if [[ -f /etc/profile.d/mysql.sh ]]; then
	loggerBold "\nSe ha agregado MySQLServer a PATH Linux"
	logger "Inicar MySQL Server : mysql.server start"
	logger "Estado MySQL Server : mysql.server status"
	logger "Detener MySQL Server : mysql.server stop"
	sudo support-files/mysql.server status
fi

# Resultado
loggerBold "\n\nSe ha instalado correctamente MySQL Server y Workbench"

# Remove temp
deleteTemp
