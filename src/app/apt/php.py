import os

from src.config import Printing

_TITLE = 'Instalación de Apache Server y PHP 8.x'


def init(manager: str):
    Printing.welcome(_TITLE)
    Printing.message('')

    Printing.title('Actualizar Sistema', True)
    os.system('sudo apt update')
    os.system('sudo apt -y upgrade')

    Printing.title('Instalación de Apache Server')
    os.system('sudo apt -y install apache2 curl')

    Printing.title('Comenzar el servicio de apache')
    os.system(f'sudo systemctl restart apache2')
    os.system(f'sudo systemctl start apache2')

    Printing.title('Instalacion de PHP')
    os.system('sudo apt -y install php8.2')

    Printing.title('Instalación de extensiones de PHP')
    os.system(f'sudo apt -y install php8.2-cgi php8.2-enchant php8.2-fpm php8.2-gd php8.2-imap php8.2-intl '
              f'php8.2-odbc php8.2-pgsql php8.2-phpdbg php8.2-pspell php8.2-snmp  php8.2-sqlite3  '
              f'php8.2-tidy php8.2-xsl php8.2-memcache')

    Printing.title('Instalacion de PHP Composer')
    os.system('curl -sS https://getcomposer.org/installer -o composer-setup.php')
    os.system('HASH=`curl -sS https://composer.github.io/installer.sig`')
    os.system('echo $HASH')

    Printing.title('Reiniciar el servico de apache')
    os.system(f'sudo systemctl restart apache2')
    os.system(f'sudo systemctl start apache2')

    Printing.title('Cambiar permisos de /srv/http y abrir navegador para ver información de php')
    os.system(f'sudo chmod 777 /srv/http/')
    os.system(f'echo "<?php phpinfo(); ?>" > /srv/http/index.php ')
    os.system(f'php --version')
    os.system(f'xdg-open http://127.0.0.1')

