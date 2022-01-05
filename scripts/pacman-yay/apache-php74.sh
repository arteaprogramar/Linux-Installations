#!/bin/bash

source $(dirname "$0")/../utils/text.sh
source $(dirname "$0")/../utils/file.sh
source $(dirname "$0")/../utils/os.sh

info "Instalación de Apache Server y PHP 7.4" "1.0"

# Actualización del sistema
loggerBold "\n\nActualizando sistema"
sudo pacman -Syu

# Instalación de Apache Sever
loggerBold "\n\nInstalación de Apache Sever"
sudo pacman -S apache

# Editar /etc/httpd/conf/httpd.conf
loggerBold "\n\nConfiguración de Módulo en /etc/httpd/conf/httpd.conf"
sudo sed -i 's,LoadModule unique_id_module modules\/mod_unique_id.so,#LoadModule unique_id_module modules\/mod_unique_id.so,' /etc/httpd/conf/httpd.conf

# Comenzar el servicio de apache
loggerBold "\n\nComenzar el servicio de apache"
sudo systemctl restart httpd
sudo systemctl start httpd

# Instalación de PHP 7.4
loggerBold "\n\nInstalación de PHP 7.4"
sudo pacman -Sy php7 php7-apache

# Instalación de extensiones
loggerBold "\n\nInstalación de extensiones de PHP"
sudo pacman -S php7-apache php7-cgi php7-dblib php7-embed php7-enchant php7-fpm php7-gd php7-imap php7-intl php7-odbc php7-pgsql php7-phpdbg php7-pspell php7-snmp php7-sodium php7-sqlite php7-tidy php7-xsl php7-mongodb php7-memcache   

# Configuración del Módulo de PHP al servirdor de Apache
loggerBold "\n\nConfiguración del Módulo de PHP al servirdor de Apache"
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
loggerBold "\n\nReiniciar el servicio de apache"
sudo systemctl restart httpd

# Configuración de Firewall
loggerBold "\n\nConfiguración de Firewall"
# sudo firewall-cmd --get-active-zones
# sudo firewall-cmd --permanent --zone=public --add-service=http
# sudo systemctl restart firewalld.service
# sudo systemctl reload firewalld

# Cambiar permisos de /srv/http 
loggerBold "\n\nAgregar todos los permisos (rwx) a /srv/http/"
sudo chmod 777 /srv/http/

# Crear archivo index.php en localhost
loggerBold "Crear archivo index.php en localhost"
echo "<?php phpinfo(); ?>" > /srv/http/index.php 

# Finalizar
loggerBold "\n\nSe ha instalado Apache Server y PHP correctamente"
loggerBold "\nAbrir localhost: http://127.0.0.1"
xdg-open http://127.0.0.1