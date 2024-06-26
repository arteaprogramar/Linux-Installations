import os
import subprocess

import main
from src.config import Printing

_TITLE = 'Instalación de Apache Server y PHP 8.x'
_SURY_REPOSITORY = 'deb https://packages.sury.org/php/ bookworm main'


def init(manager: str):
    Printing.welcome(_TITLE)
    Printing.message('')

    Printing.title('Agregar repositorios sury al sistema', True)

    if is_debian():
        os.system(f'sudo apt install lsb-release apt-transport-https ca-certificates  wget -y')
        os.system(f'sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg')
        os.system(
            f"sudo sh -c 'echo \"deb https://packages.sury.org/php/ bookworm main\" > /etc/apt/sources.list.d/php.list '")

    if not is_debian():
        os.system(f'sudo add-apt-repository ppa:ondrej/php')

    Printing.title('Actualizar reposotorios')
    os.system('sudo apt update')

    Printing.title('Instalación de Apache Server')
    os.system('sudo apt -y install apache2 curl')

    Printing.title('Comenzar el servicio de apache')
    os.system(f'sudo systemctl restart apache2')
    os.system(f'sudo systemctl start apache2')

    Printing.title('Obtener versiones disponibles de PHP')
    selected = -1
    continue_menu = True

    try:
        result = subprocess.run(
            "apt-cache search php | egrep '^php[0-9]+\\.[0-9]+[[:space:]]+-[[:space:]]' | awk '{print $1}' | sed 's/php//'",
            shell=True,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )

        versions = result.stdout.decode('utf-8').strip().split('\n')

        for index, version in enumerate(versions):
            Printing.message(f"Para instalar PHP \033[1m{version}\033[0m ingrese \033[1m{index}\033[0m")

        while continue_menu:
            selected = main.parser_int(input('¿Que version de PHP deseas instalar? : '))

            if selected <= len(versions):
                continue_menu = False

        Printing.title('Instalacion de PHP')
        php_version = f'php{selected}'
        os.system(f'sudo apt -y install {php_version}')

        Printing.title('Instalación de extensiones de PHP')
        os.system(f'sudo apt -y install  {php_version}-cgi  {php_version}-enchant  {php_version}-fpm  {php_version}-gd '
                  f'{php_version}-imap {php_version}-intl {php_version}-odbc {php_version}-pgsql {php_version}-phpdbg '
                  f'{php_version}-pspell  {php_version}-snmp {php_version}-sqlite3 {php_version}-tidy '
                  f'{php_version}-xsl  {php_version}-memcache  {php_version}-zip  {php_version}-curl')

        Printing.title('Cargar módulo de PHP a Apache Server')
        os.system(f'sudo apt install -y libapache2-mod-{php_version}')

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

    except subprocess.CalledProcessError as e:
        print(f"Error: {e.stderr.decode('utf-8')}")


def is_debian():
    try:
        if os.path.exists("/etc/os-release"):
            with open("/etc/os-release") as f:
                for line in f:
                    if line.startswith("ID="):
                        distribution_id = line.strip().split("=")[1].strip('"')
                        return distribution_id == "debian"
        return False
    except Exception as e:
        print(f"Error: {e}")
        return False
