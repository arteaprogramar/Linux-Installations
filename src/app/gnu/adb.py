import os

from src.app.common import wget_util, uncompress
from src.config import PackageManager, TemporalFile, SystemInformation

_TITLE = 'Instalación de Android Platforms Tools'

_ADB_PATH_LINUX = '/etc/profile.d/adb.sh'
_ADB_VERSION = 'platform-tools-latest-linux.zip'
_ADB_PATH = '/opt/platform-tools'

_EXPORT_PATH = """#!/bin/sh
export ADB_HOME=/opt/platform-tools
export PATH=\${ADB_HOME}:\${PATH}
"""


def init(manager: str):
    printing.title(_TITLE)

    # Dependecias
    wget_installed = PackageManager.pkg_has_installed('Comprobar WGET', manager, 'wget')
    unzip_installed = PackageManager.pkg_has_installed('Comprobar UNZIP', manager, 'unzip')

    if not wget_installed & unzip_installed:
        printing.warning('Se requieren las depencias WGET y/o UNZIP para ejecutar este script')

    PackageManager.clear()
    start()


def start():
    printing.welcome(_TITLE)
    printing.message('WGET y UNZIP estan disponibles en el script')

    printing.title('Crear carpeta temporal')
    temp_created = TemporalFile.temp_folder_create()

    if not temp_created:
        printing.warning('No se ha podido crear la carpeta temporal')
        return

    printing.title('Descarga de ADB')
    wget_util.download(f'https://dl.google.com/android/repository/{_ADB_VERSION}')

    printing.title('Descomprimir ADB')
    uncompress.unzip(f'{TemporalFile.FOLDER_TEMP}/{_ADB_VERSION}', TemporalFile.FOLDER_TEMP)

    printing.title('Mover ADB a /opt/')
    SystemInformation.request_root_permission()
    os.system(f'sudo mv temp/platform-tools {_ADB_PATH}')

    printing.title('Agregar adb al Path de Linux')
    os.system(f'echo """{_EXPORT_PATH}""" | sudo tee -a {_ADB_PATH_LINUX}')

    printing.title('Agregar permiso de ejecución al adb en el path de Linux')
    os.system(f'sudo chmod +x {_ADB_PATH_LINUX}')

    try:
        os.system(f"su -c '{_ADB_PATH_LINUX}' root")

        printing.title('Mostrar información del adb')
        os.system(f'{_ADB_PATH}/adb --version')

        printing.message('En algunas distribuciones requiere reiniciar el sistema')
    except OSError:
        printing.warning('Deberá ejecutar el siguiente comando para agregar ADB al PATH de Linux')
        printing.message(f'source {_ADB_PATH_LINUX}')

    TemporalFile.folder_delete('temp')
