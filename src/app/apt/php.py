import os
import platform

from src.config import Printing

_TITLE = 'Instalación de Apache Server y PHP 8.x'
_SURY_REPOSITORY = 'deb https://packages.sury.org/php/ bookworm main'


def init(manager: str):
    Printing.welcome(_TITLE)
    Printing.message('')

    Printing.title('Actualizar Sistema', True)

    if is_debian():
        os.system(f'sudo apt install apt-transport-https lsb-release ca-certificates wget -y')
        os.system(f'sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg')
        #os.system(f"sudo sh -c 'echo {_SURY_REPOSITORY} > /etc/apt/sources.list.d/php.list '")
        os.system(f"sudo sh -c \"echo '{_SURY_REPOSITORY}' > /etc/apt/sources.list.d/php.list\"")

    if not is_debian():
        os.system(f'sudo add-apt-repository ppa:ondrej/php')

    Printing.title('Instalación de Apache Server')
    os.system('sudo apt -y install apache2 curl libapache2-mod-php libapache2-mod-php8.3')

    Printing.title('Comenzar el servicio de apache')
    os.system(f'sudo systemctl restart apache2')
    os.system(f'sudo systemctl start apache2')

    Printing.title('Actualizar')
    os.system('sudo apt update')
    os.system('sudo apt -y upgrade')

    Printing.title('Instalacion de PHP')
    os.system('sudo apt -y install php8.3')

    Printing.title('Instalación de extensiones de PHP')
    os.system(f'sudo apt -y install php8.3-cgi php8.3-enchant php8.3-fpm php8.3-gd php8.3-imap php8.3-intl '
              f'php8.3-odbc php8.3-pgsql php8.3-phpdbg php8.3-pspell php8.3-snmp  php8.3-sqlite3  '
              f'php8.3-tidy php8.3-xsl php8.3-memcache php8.3-zip php8.3-curl')

    Printing.title('Instalacion de PHP Composer')
    os.system('curl -sS https://getcomposer.org/installer -o composer-setup.php')
    os.system('HASH=`curl -sS https://composer.github.io/installer.sig`')
    os.system('echo $HASH')
    os.system('php composer-setup.php')
    os.system('php -r "unlink(\'composer-setup.php\');" ')
    os.system('sudo mv composer.phar /usr/local/bin/composer')

    Printing.title('Reiniciar el servico de apache')
    os.system(f'sudo systemctl restart apache2')
    os.system(f'sudo systemctl start apache2')
    os.system(f'sudo systemctl enable apache2')

    Printing.title('Cambiar permisos de /srv/http y abrir navegador para ver información de php')
    os.system(f'sudo chmod 777 /var/www/')
    os.system(f'echo "<?php phpinfo(); ?>" > /var/www/index.php ')
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
