import os
import platform

from src.config import Printing

_TITLE = 'Instalación de Apache Server y PHP 8.x'
_SURY_REPOSITORY = 'deb https://packages.sury.org/php/ $(lsb_release -sc) main'


def init(manager: str):
    Printing.welcome(_TITLE)
    Printing.message('')

    Printing.title('Actualizar Sistema', True)
    os.system('sudo apt update')
    os.system('sudo apt -y upgrade')

    if is_debian():
        os.system(f'sudo apt install apt-transport-https lsb-release ca-certificates wget -y')
        os.system(f'sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg')
        os.system(f"sudo sh -c 'echo {_SURY_REPOSITORY} > /etc/apt/sources.list.d/php.list '")

    if not is_debian():
        os.system(f'sudo add-apt-repository ppa:ondrej/php')

    Printing.title('Instalación de Apache Server')
    os.system('sudo apt -y install apache2 curl libapache2-mod-php8.2')

    Printing.title('Comenzar el servicio de apache')
    os.system(f'sudo systemctl restart apache2')
    os.system(f'sudo systemctl start apache2')



    Printing.title('Actualizar')
    os.system(f'sudo apt -y update')

    Printing.title('Instalacion de PHP')
    os.system('sudo apt -y install php8.2')

    Printing.title('Instalación de extensiones de PHP')
    os.system(f'sudo apt -y install php8.2-cgi php8.2-enchant php8.2-fpm php8.2-gd php8.2-imap php8.2-intl '
              f'php8.2-odbc php8.2-pgsql php8.2-phpdbg php8.2-pspell php8.2-snmp  php8.2-sqlite3  '
              f'php8.2-tidy php8.2-xsl php8.2-memcache ')

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


def is_debian():
    try:
        distro = platform.linux_distribution()
        name = distro[0].lower()

        if 'ubuntu' in name:
            return False
        elif 'debian' in name:
            return True
        else:
            return False
    except Exception as e:
        return False
