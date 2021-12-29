#!/bin/bash

logger(){
    echo -e $1 $2 $3
}

osName=$((egrep '^(ID)=' /etc/os-release) | awk -F = {'print $2'})

# Limpiar consola
echo $(clear)

# Mostrar informacion del Script
logger "Arte a Programar"
logger "Script para instalar Apache Server & PHP 7.4"
logger "v0.1\n"
logger "OS : " $osName

# Actualización del sistema
logger "\n\nActualizando sistema"
sudo pacman -Syu

# Instalación de Apache Sever
logger "\n\nInstalación de Apache Sever"
sudo pacman -S apache

# Editar /etc/httpd/conf/httpd.conf
logger "\n\nConfiguración de Módulo en /etc/httpd/conf/httpd.conf"
sudo sed -i 's,LoadModule unique_id_module modules\/mod_unique_id.so,#LoadModule unique_id_module modules\/mod_unique_id.so,' /etc/httpd/conf/httpd.conf

# Comenzar el servicio de apache
logger "\n\nComenzar el servicio de apache"
sudo systemctl restart httpd
sudo systemctl start httpd

# Instalación de PHP 7.4
logger "\n\nInstalación de PHP 7.4"
sudo pacman -Sy php7 php7-apache

# Instalación de extensiones
logger "\n\nInstalación de extensiones de PHP"
sudo pacman -S php7-apache php7-cgi php7-dblib php7-embed php7-enchant php7-fpm php7-gd php7-imap php7-intl php7-odbc php7-pgsql php7-phpdbg php7-pspell php7-snmp php7-sodium php7-sqlite php7-tidy php7-xsl php7-mongodb php7-memcache   

# Configuración del Módulo de PHP al servirdor de Apache
logger "\n\nConfiguración del Módulo de PHP al servirdor de Apache"
sudo chmod 666 /etc/httpd/conf/httpd.conf
sudo sed -i 's,LoadModule mpm_event_module modules\/mod_mpm_event.so,# LoadModule mpm_event_module modules/mod_mpm_event.so,' /etc/httpd/conf/httpd.conf

# Variable para configuración de PHP
phpConfig="
LoadModule mpm_prefork_module modules/mod_mpm_prefork.so                \n
                                                                        \n
## Para PHP 7.x                                                         \n
LoadModule php7_module modules/libphp7.so                               \n
AddHandler php7-script php                                              \n
Include conf/extra/php7_module.conf                                     \n
                                                                        \n
## Opcional                                                             \n
<IfModule dir_module>                                                   \n
\t    <IfModule php7_module>                                            \n
\t        DirectoryIndex index.php index.html                           \n
\t        <FilesMatch \"\.php$\">                                       \n
\t\t            SetHandler application/x-httpd-php                      \n
\t        </FilesMatch>                                                 \n
\t        <FilesMatch \"\.phps$\">                                      \n
\t\t            SetHandler application/x-httpd-php-source               \n
\t        </FilesMatch>                                                 \n
\t    </IfModule>                                                       \n
</IfModule>                                                             \n
"

sudo echo -e $phpConfig >> /etc/httpd/conf/httpd.conf

# Reiniciar el servico de apache
logger "\n\nReiniciar el servicio de apache"
sudo systemctl restart httpd

# Configuración de Firewall
logger "\n\nConfiguración de Firewall"
# sudo firewall-cmd --get-active-zones
# sudo firewall-cmd --permanent --zone=public --add-service=http
# sudo systemctl restart firewalld.service
# sudo systemctl reload firewalld

# Cambiar permisos de /srv/http 
logger "\n\nAgregar todos los permisos (rwx) a /srv/http/"
sudo chmod 777 /srv/http/

# Crear archivo index.php en localhost
logger "Crear archivo index.php en localhost"
echo "<?php phpinfo(); ?>" > /srv/http/index.php 

# Finalizar
logger "\n\nSe ha instalado Apache Server y PHP correctamente"
logger "\nAbrir localhost: http://127.0.0.1"
xdg-open http://127.0.0.1