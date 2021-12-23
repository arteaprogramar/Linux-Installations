#!/bin/bash

logger(){
	echo -e $1 $2
}

fedoraRelease=$(cat /etc/*-release | grep "VERSION_ID=")
fedoraId=$(echo $fedoraRelease | awk -F = {'print $2'})


# Limpiar consola
echo $(clear)

# Mostrar informacion del Script
logger "Arte a Programar"
logger "Script para instalar MySQL Server 5.7"
logger "Se require Fedora 31+"
logger "v0.1\n"
logger "OS : Fedora" $fedoraId

# Comprobación de versión
if [[ $fedoraId -ge 31 ]]; then
	logger "Fedora ${fedoraId} es compatible\n"

	# Actualizar sistema
	logger "Actualizar sistema"
	sudo dnf -y update

	# Descarga e instalación de MySQL Repository
	logger "\nDescarga e instalación de MySQL Repository"
	sudo dnf -y install http://repo.mysql.com/mysql80-community-release-fc"$fedoraId".rpm

	# Modificar mysql-community.repo
	logger "\nModificar mysql-community.repo para instalar MySQL 5.7"
	sudo sed -i 's/mysql80-community/mysql57-community/' /etc/yum.repos.d/mysql-community.repo
	sudo sed -i 's/MySQL 8.0/MySQL 5.7/' /etc/yum.repos.d/mysql-community.repo 
	sudo sed -i 's,mysql-8.0-community\/fc\/$releasever,mysql-5.7-community\/fc\/31,' /etc/yum.repos.d/mysql-community.repo 

	# Instalar MySQL 5.7
	logger "\nInstalación de MySQL Server 5.7"
	sudo dnf -y install mysql-community-server

	# Comenzar MySQL Server
	logger "\nComenzar servicio de MySQL"
	sudo systemctl start mysqld

	# Obtener contraseña temporal
	logger "\nObtener contraseña temporal"
	sudo grep 'temporary password' /var/log/mysqld.log

	# Configuración de seguridad de MySQL
	logger "\nConfiguración de seguridad de MySQL"
	sudo /usr/bin/mysql_secure_installation

	# Configurar Firewall
	logger "\nConfiguración de Firewall"
	sudo firewall-cmd --permanent --zone=public --add-service=mysql
	sudo firewall-cmd --permanent --zone=public --add-port=3306/tcp
	sudo systemctl restart firewalld.service
	sudo systemctl restart mysqld

	# Instalar MySQL Workbench
	logger "\nIntentar instalar MySQL Workbench"
	sudo dnf -y install mysql-workbench-community

	# Felicitaciones
	logger "\n\nSe ha instalado Correctamente MySQL Server 5.7"
else
	logger "Script require Fedora 31 o superior"
fi