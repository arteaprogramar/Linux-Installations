import os

from src.config import Printing

_TITLE = 'Instalación de Apache Server y PHP 8.x'

php7_config = """
LoadModule mpm_prefork_module modules/mod_mpm_prefork.so

## Cargar PHP
LoadModule php7_module modules/libphp7.so
AddHandler php7-script .php
Include conf/extra/php7_module.conf

## Opcional
<IfModule dir_module>
    <IfModule php7_module>
        DirectoryIndex index.php index.html
        <FilesMatch "\.php$">
            SetHandler application/x-httpd-php
        </FilesMatch>
        <FilesMatch "\.phps$">
            SetHandler application/x-httpd-php-source
        </FilesMatch>
    </IfModule>
</IfModule>
"""


def init(manager: str):
    Printing.welcome(_TITLE)
    Printing.message('')

    Printing.title('Actualizar Sistema', True)
    os.system('sudo pacman -Syu --noconfirm')

    Printing.title('Instalación de Apache Server')
    os.system(f'sudo pacman -S apache --noconfirm')

    Printing.title('Editar /etc/httpd/conf/httpd.conf')
    os.system(f'sudo chmod 666 /etc/httpd/conf/httpd.conf')
    os.system(f"sudo sed -i 's,LoadModule unique_id_module modules\/mod_unique_id.so,#LoadModule unique_id_module modules\/mod_unique_id.so,' /etc/httpd/conf/httpd.conf")

    Printing.title('Comenzar el servicio de apache')
    os.system(f'sudo systemctl restart httpd')
    os.system(f'sudo systemctl start httpd')

    Printing.title('Instalacion de PHP')
    os.system(f'sudo pacman -S php php-apache --noconfirm')

    Printing.title('Instalación de extensiones de PHP')
    os.system(f'sudo pacman -S php-apache php-cgi php-dblib php-embed php-enchant php-fpm php-gd php-imap php-intl '
              f'php-odbc php-pgsql php-phpdbg php-pspell php-snmp php-sodium php-sqlite php-tidy php-xsl php-mongodb '
              f'php-memcache  --noconfirm')

    Printing.title('Instalacion de PHP Composer')
    os.system(f'sudo pacman -S composer --noconfirm')

    Printing.title(f'Configuración del Módulo de PHP al servirdor de Apache')
    os.system(f'sudo chmod 666 /etc/httpd/conf/httpd.conf')
    os.system(f"sudo sed -i 's,LoadModule mpm_event_module modules\/mod_mpm_event.so,# LoadModule mpm_event_module modules/mod_mpm_event.so,' /etc/httpd/conf/httpd.conf")

    Printing.title(f'Cargar módulos de PHP a Apache Server')
    os.system(f'sudo echo -e "{php7_config}" >> /etc/httpd/conf/httpd.conf')
    os.system(f"sudo sed -i 's/php7_module/php_module/' /etc/httpd/conf/httpd.conf")
    os.system(f"sudo sed -i 's/libphp7/libphp/' /etc/httpd/conf/httpd.conf")
    os.system(f"sudo sed -i 's/php7-script/php-script/' /etc/httpd/conf/httpd.conf")

    Printing.title('Reiniciar el servico de apache')
    os.system(f'sudo systemctl restart httpd')

    Printing.title('Cambiar permisos de /srv/http y abrir navegador para ver información de php')
    os.system(f'sudo chmod 777 /srv/http/')
    os.system(f'echo "<?php phpinfo(); ?>" > /srv/http/index.php ')
    os.system(f'php --version')
    os.system(f'xdg-open http://127.0.0.1')

