#!/bin/bash

source $(dirname "$0")/../utils/os.sh
source $(dirname "$0")/../utils/file.sh
source $(dirname "$0")/../utils/text.sh

info "Instalación de Apache Server y PHP (Repositorios Oficiales)" "1.1"
loggerBold "*Este script ha sido probado en ArchLinux/EndeavourOS/Manjaro*"

# Documentacion
documentation "Wiki Arch" "https://wiki.archlinux.org/title/PHP"

# Variables
php7Config="
LoadModule mpm_prefork_module modules/mod_mpm_prefork.so                \n
                                                                        \n
## Cargar PHP                                                           \n
LoadModule php7_module modules/libphp7.so                               \n
AddHandler php7-script .php                                             \n
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

# Realizar actualización del Sistema
loggerBold "Realizando actualización del sistema"
sudo pacman -Syu --noconfirm

# Instalación de Apache Server
loggerBold "\n\nInstalación de Apache Server"
sudo pacman -S apache --noconfirm

# Editar /etc/httpd/conf/httpd.conf
loggerBold "\n\nConfiguración de Módulo en /etc/httpd/conf/httpd.conf"
sudo chmod 666 /etc/httpd/conf/httpd.conf
sudo sed -i 's,LoadModule unique_id_module modules\/mod_unique_id.so,#LoadModule unique_id_module modules\/mod_unique_id.so,' /etc/httpd/conf/httpd.conf

# Comenzar el servicio de apache
loggerBold "\n\nComenzar el servicio de apache"
sudo systemctl restart httpd
sudo systemctl start httpd

# Versiones disponibles de PHP en los repositorios oficiales
loggerBold "\n\nVersiones disponibles de PHP en los repositorios oficiales"
search=$(pacman -Ss php | egrep '/php[0-9]{0,2}[[:space:]]' | awk -F 'extra/php[0-9]{0,2}[[:space:]]' {'print $2'})
declare -a names=($search)
search=$(echo "$search" |  awk -F '.' {'print $1'})
declare -a versions=($search)

# Mostrar menu de versiones disponibles de PHP oficial
loggerBold "\nMenú de versiones disponibles de PHP"
logger "Ingrese un número según la versión de PHP que desea instalar:"
counter=0

for i in "${versions[@]}"; do
    logger "Para instalar PHP \033[1m${names[$counter]}\033[0m ingrese : \033[1m$counter\033[0m"
    ((counter++))
done

# Instalación de PHP
versionToInstall=""
while [[ ! $versionToInstall =~ ^[0-9]{1,2} ]]; do
    read -p "¿Que versión de PHP desea que desea instalar? : " versionToInstall

    if [[ ! $versionToInstall =~ ^[0-9]{1,2} ]]; then
        versionToInstall=""
    elif [ $versionToInstall -ge $counter ]; then
        versionToInstall=""
    else
        # Instalación
        loggerBold "\n\nInstalación de PHP"
        php=$(echo "${versions[$versionToInstall]}")

        if [ $php -ge 8 ]; then
            sudo pacman -S php php-apache --noconfirm

            # PHP Extensions
            loggerBold "\n\nInstalación de extensiones de PHP"
            sudo pacman -S php-apache php-cgi php-dblib php-embed php-enchant php-fpm php-gd php-imap php-intl php-odbc php-pgsql php-phpdbg php-pspell php-snmp php-sodium php-sqlite php-tidy php-xsl php-mongodb php-memcache  --noconfirm
        else 
            sudo pacman -S php"$php" php"$php"-apache  --noconfirm

            # PHP Extensions
            loggerBold "\n\nInstalación de extensiones de PHP"
            sudo pacman -S php"$php"-apache php"$php"-cgi php"$php"-dblib php"$php"-embed php"$php"-enchant php"$php"-fpm php"$php"-gd php"$php"-imap php"$php"-intl php"$php"-odbc php"$php"-pgsql php"$php"-phpdbg php"$php"-pspell php"$php"-snmp php"$php"-sodium php"$php"-sqlite php"$php"-tidy php"$php"-xsl php"$php"-mongodb php"$php"-memcache  --noconfirm
        fi

        # Configuración del Módulo de PHP al servirdor de Apache
        loggerBold "\n\nConfiguración del Módulo de PHP al servirdor de Apache"
        sudo chmod 666 /etc/httpd/conf/httpd.conf
        sudo sed -i 's,LoadModule mpm_event_module modules\/mod_mpm_event.so,# LoadModule mpm_event_module modules/mod_mpm_event.so,' /etc/httpd/conf/httpd.conf

        # Variable para configuración de PHP
        loggerBold "\n\nCargar módulos de PHP a Apache Server"
        sudo echo -e $php7Config >> /etc/httpd/conf/httpd.conf

        if [ $php -ge 8 ]; then
            sudo sed -i 's/php7_module/php_module/' /etc/httpd/conf/httpd.conf
            sudo sed -i 's/libphp7/libphp/' /etc/httpd/conf/httpd.conf
            sudo sed -i 's/php7-script/php-script/' /etc/httpd/conf/httpd.conf
        fi

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

        # PHP Version
        loggerBold "\n\nPHP Version"
        {
            php --version
        } || {
            php"$php" --version
        }

        # Finalizar
        loggerBold "\n\nSe ha instalado Apache Server y PHP correctamente"
        loggerBold "\nAbrir localhost: http://127.0.0.1"
        xdg-open http://127.0.0.1
    fi
done