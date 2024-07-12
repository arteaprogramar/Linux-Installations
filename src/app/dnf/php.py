import os
import subprocess

import main
from src.config import Printing

_TITLE = 'Instalación de Apache Server y PHP 8.x'


def init(manager: str):
    Printing.welcome(_TITLE)
    Printing.message('')

    Printing.title('Actualizar reposotorios')
    os.system('sudo dnf -y update')

    Printing.title('Instalación de Apache Server')
    os.system('sudo dnf -y install httpd')

    Printing.title('Comenzar el servicio de apache')
    os.system(f'sudo systemctl restart httpd')
    os.system(f'sudo systemctl start httpd')

    Printing.title('Instalacion de PHP')
    php_version = 'php'
    os.system(f'sudo dnf -y install {php_version} {php_version}-common')

    Printing.title('Instalación de extensiones de PHP')
    os.system(f'sudo dnf -y install  {php_version}-cgi  {php_version}-enchant  {php_version}-fpm  {php_version}-gd '
                f'{php_version}-intl {php_version}-odbc {php_version}-pgsql {php_version}-dbg '
                f'{php_version}-pspell  {php_version}-snmp {php_version}-sqlite3 {php_version}-tidy '
                f'{php_version}-xsl  {php_version}-memcache  {php_version}-zip  {php_version}-curl')
                

    Printing.title('Instalacion de PHP Composer')
    # os.system('curl -sS https://getcomposer.org/installer -o composer-setup.php')
    # os.system('HASH=`curl -sS https://composer.github.io/installer.sig`')
    # os.system('echo $HASH')
    # os.system('php composer-setup.php')
    # os.system('php -r "unlink(\'composer-setup.php\');" ')
    # os.system('sudo mv composer.phar /usr/local/bin/composer')
    os.system(f'sudo dnf -y install composer')

    Printing.title('Reiniciar el servico de apache')
    os.system(f'sudo systemctl restart apache2')
    os.system(f'sudo systemctl start apache2')
    os.system(f'sudo systemctl enable apache2')

    Printing.title('Cambiar permisos de /srv/http y abrir navegador para ver información de php')
    os.system(f'sudo chmod 777 /var/www/')
    os.system(f'echo "<?php phpinfo(); ?>" > /var/www/index.php ')
    os.system(f'php --version')
    os.system(f'xdg-open http://127.0.0.1')


