import os
import subprocess

from src.app.common import menu, wget_util, uncompress
from src.config import Printing, PackageManager, TemporalFile, SystemInformation

_TITLE = 'Instalación de MySQL Server'

_MYSQL_VERSION = 'mysql-{}-linux-glibc2.12-{}'
_MYSQL_PATH_LINUX = '/etc/profile.d/mysql.sh'
_MYSQL_PATH = '/opt/MySQL'
_ARCH = SystemInformation.getInformation.get_arch()

_EXPORT_PATH = """#!/bin/sh
export MYSQL_HOME=/opt/MySQL
export PATH=\${MYSQL_HOME}/bin:\${PATH}
"""


def init(manager: str):
    Printing.welcome(_TITLE)
    Printing.message('')

    # Dependecias
    Printing.title('Comprobar version de Java')
    installed = PackageManager.pkg_exists('yay')

    if not installed:
        Printing.warning('Se requiere tener instalado el Helper AUR YAY')
        return

    Printing.title('Instalación de dependencias')
    PackageManager.pkg_has_installed('Instalación de libaio', manager, 'libaio')
    PackageManager.pkg_has_installed('Instalación de numactl', manager, 'numactl')
    PackageManager.pkg_has_installed('Instalación de libcrypt.so.1 legacy', manager, 'libxcrypt-compat')

    Printing.title('Instalación de ncurses5-compat-libs')
    # PackageManager.yay_install('ncurses5-compat-libs')

    start()

def start():
    Printing.welcome(_TITLE)
    Printing.title('Crear carpeta temporal')
    TemporalFile.temp_folder_create()

    mysql_versions = [5.7, 8.0]
    menu.show_menu('Versiones disponibles de MySQL Server', mysql_versions)
    selected = menu.select_item(mysql_versions)

    print(selected)

    # Version de MySQL Seleccionada
    basename = ''
    mysql = mysql_versions[selected]

    if selected == 0:
        Printing.title('Descargar MySQL Server 5.7')
        basename = f"{_MYSQL_VERSION.format('5.7.40', _ARCH)}"
        wget_util.download(f"https://dev.mysql.com/get/Downloads/MySQL-{mysql}/{basename}.tar.gz")
        uncompress.un_targz(f"temp/{basename}.tar.gz", TemporalFile.FOLDER_TEMP)

    if selected == 1:
        Printing.title('Descargar MySQL Server 8')
        basename = f"{_MYSQL_VERSION.format('8.0.31', _ARCH)}"
        wget_util.download(f"https://dev.mysql.com/get/Downloads/MySQL-{mysql}/{basename}.tar.xz")
        uncompress.un_tarxz(f"temp/{basename}.tar.xz", TemporalFile.FOLDER_TEMP)

    Printing.title('Mover MySQL a /opt/')
    SystemInformation.request_root_permission()
    os.system(f"sudo mv temp/{basename} {_MYSQL_PATH}")

    Printing.title('Agregar MySQL al Path de Linux')
    os.system(f'echo """{_EXPORT_PATH}""" | sudo tee -a {_MYSQL_PATH_LINUX}')

    Printing.title('Agregar permiso de ejecución al Gradle en el path de Linux')
    os.system(f'sudo chmod +x {_MYSQL_PATH_LINUX}')

    Printing.title('Configuración de MySQL Server')
    os.system('sudo groupadd mysql')
    os.system('sudo useradd -r -g mysql -s /bin/false mysql')
    os.system(f'sudo ln -s {_MYSQL_PATH} /usr/local/mysql')
    os.system(f'sudo mkdir {_MYSQL_PATH}/mysql-files')
    os.system(f'sudo chown mysql:mysql {_MYSQL_PATH}/mysql-files')
    os.system(f'sudo chmod 750 {_MYSQL_PATH}/mysql-files')

    Printing.title('Inicializar MySQL para obtener contraseña temporal')
    temporal = subprocess.check_output(f'sudo {_MYSQL_PATH}/bin/mysqld --initialize --user=mysql', shell=True, text=True)
    os.system(f'sudo {_MYSQL_PATH}/bin/mysql_ssl_rsa_setup')
    os.system(f'sudo {_MYSQL_PATH}/bin/mysqld_safe --user=mysql &')

    Printing.title('Conocer el estado del Servicio de MySQL Server')
    os.system(f'sudo cp {_MYSQL_PATH}/support-files/mysql.server {_MYSQL_PATH}/bin/mysql.server')
    os.system(f'{_MYSQL_PATH}/support-files/mysql.server status')

    Printing.title('IMPORTANTE!!!')
    Printing.title('Ingresa la contraseña temporal generada por MySQL en el paso anterior.')
    temporal_password = list(filter(lambda pkg: "root@localhost:" in pkg, temporal.split('\n')))

    if len(temporal_password) > 0:
        secret = temporal_password[0]
        Printing.title(f"Su contraseña temporal es: {secret[secret.find(': ') + 1:]}")

    os.system(f'{_MYSQL_PATH}/support-files/mysql.server start')
    os.system(f'{_MYSQL_PATH}/bin/mysql_secure_installation')

    Printing.title('Se ha instalado correctamente MySQL Server')
    Printing.message('Inicar MySQL Server : mysql.server start')
    Printing.message('Estado MySQL Server : mysql.server status')
    Printing.message('Detener MySQL Server : mysql.server stop')
    os.system(f'{_MYSQL_PATH}/support-files/mysql.server status')

    Printing.message('En algunas distribuciones requiere reiniciar el sistema')
    TemporalFile.folder_delete(TemporalFile.FOLDER_TEMP)