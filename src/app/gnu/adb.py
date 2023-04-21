import os

from src.app.common import wget_util, uncompress
from src.config import PackageManager, TemporalFile, SystemInformation, Printing

_TITLE = 'Instalación de Android Platforms Tools'

_ADB_PATH_LINUX = '/etc/profile.d/adb.sh'
_ADB_VERSION = 'platform-tools-latest-linux.zip'
_ADB_PATH = '/opt/platform-tools'

_EXPORT_PATH = """#!/bin/sh
export ADB_HOME=/opt/platform-tools
export PATH=\${ADB_HOME}:\${PATH}
"""


def init(manager: str):
    Printing.title(_TITLE)

    # Dependecias
    wget_installed = PackageManager.pkg_has_installed('Comprobar WGET', manager, 'wget')
    unzip_installed = PackageManager.pkg_has_installed('Comprobar UNZIP', manager, 'unzip')

    if not wget_installed & unzip_installed:
        Printing.warning('Se requieren las depencias WGET y/o UNZIP para ejecutar este script')

    PackageManager.clear()
    start()


def start():
    Printing.welcome(_TITLE)
    Printing.message('WGET y UNZIP estan disponibles en el script')

    Printing.title('Crear carpeta temporal')
    temp_created = TemporalFile.temp_folder_create()

    if not temp_created:
        Printing.warning('No se ha podido crear la carpeta temporal')
        return

    Printing.title('Descarga de ADB')
    wget_util.download(f'https://dl.google.com/android/repository/{_ADB_VERSION}')

    Printing.title('Descomprimir ADB')
    uncompress.unzip(f'{TemporalFile.FOLDER_TEMP}/{_ADB_VERSION}', TemporalFile.FOLDER_TEMP)

    Printing.title('Mover ADB a /opt/')
    # SystemInformation.request_root_permission()
    os.system(f'sudo mv temp/platform-tools {_ADB_PATH}')

    Printing.title('Agregar adb al Path de Linux')
    os.system(f'echo """{_EXPORT_PATH}""" | sudo tee -a {_ADB_PATH_LINUX}')

    Printing.title('Agregar permiso de ejecución al adb en el path de Linux')
    os.system(f'sudo chmod +x {_ADB_PATH_LINUX}')

    try:
        Printing.title(f'Se require su contraseña para aplicar el comando $ source {_ADB_PATH_LINUX}')
        Printing.warning('En caso de no ingresar de manera exitosa su contraseña, favor de ejecutar manualmente')
        Printing.message(f'source {_ADB_PATH_LINUX}')
        os.system(f"su -c 'source {_ADB_PATH_LINUX}' root")

        Printing.title('Mostrar información del adb')
        os.system(f'{_ADB_PATH}/adb --version')

        Printing.message('En algunas distribuciones requiere reiniciar el sistema')
    except OSError:
        Printing.warning('Deberá ejecutar el siguiente comando para agregar ADB al PATH de Linux')
        Printing.message(f'source {_ADB_PATH_LINUX}')

    TemporalFile.folder_delete('temp')
