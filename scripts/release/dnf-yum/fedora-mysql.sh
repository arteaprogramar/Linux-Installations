#!/bin/bash

source $(dirname "$0")/../../utils/os.sh
source $(dirname "$0")/../../utils/file.sh
source $(dirname "$0")/../../utils/text.sh

info "Instalación de MySQL Server 5.7" "1.0"

# Variables
osName=$(getNameOs)
osNumber=$(getVersionOs)

# Comprobación de versión
if [[ $osNumber -ge 31 ]]; then
	loggerBold "Fedora ${osNumber} es compatible\n"

	# Actualizar sistema
	loggerBold "Actualizar sistema"
	sudo dnf -y update

	# Descarga e instalación de MySQL Repository
	loggerBold "\nDescarga e instalación de MySQL Repository"
	sudo dnf -y install http://repo.mysql.com/mysql80-community-release-fc"$osNumber".rpm

	# Modificar mysql-community.repo
	loggerBold "\nModificar mysql-community.repo para instalar MySQL 5.7"
	sudo sed -i 's/mysql80-community/mysql57-community/' /etc/yum.repos.d/mysql-community.repo
	sudo sed -i 's/MySQL 8.0/MySQL 5.7/' /etc/yum.repos.d/mysql-community.repo 
	sudo sed -i 's,mysql-8.0-community\/fc\/$releasever,mysql-5.7-community\/fc\/31,' /etc/yum.repos.d/mysql-community.repo 

	# Instalar MySQL 5.7
	loggerBold "\nInstalación de MySQL Server 5.7"
	sudo dnf -y install mysql-community-server

	# Comenzar MySQL Server
	loggerBold "\nComenzar servicio de MySQL"
	sudo systemctl start mysqld

	# Obtener contraseña temporal
	loggerBold "\nObtener contraseña temporal"
	sudo grep 'temporary password' /var/log/mysqld.log

	# Configuración de seguridad de MySQL
	loggerBold "\nConfiguración de seguridad de MySQL"
	logger "Ingresar contraseña temporal"
	logger "Nota: En caso de equivocarse al ingresar la contraseña temporal"
	logger "Tendrá que ejecutar el siguiente comando manualmente"
	logger "$ sudo /usr/bin/mysql_secure_installation"
	sudo /usr/bin/mysql_secure_installation

	# Configurar Firewall
	loggerBold "\nConfiguración de Firewall"
	sudo firewall-cmd --permanent --zone=public --add-service=mysql
	sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
	sudo systemctl restart firewalld.service
	sudo systemctl restart mysqld

	# Instalar MySQL Workbench
	loggerBold "\nIntentar instalar MySQL Workbench"
	sudo dnf -y install mysql-workbench-community

	# Felicitaciones
	loggerBold "\n\nSe ha instalado Correctamente MySQL Server 5.7"
else
	loggerBold "Script require Fedora 31 o superior"
fi