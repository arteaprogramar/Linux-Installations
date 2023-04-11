import os

from src.app.common import wget_util, uncompress
from src.config import PackageManager, TemporalFile, SystemInformation

_TITLE = 'Instalación de Flutter'

_FLUTTER_VERSION = 'flutter_linux_3.7.10-stable.tar.xz'
_FLUTTER_PATH_LINUX = '/etc/profile.d/flutter.sh'
_FLUTTER_PATH= '/opt/Flutter'

_EXPORT_PATH = """#!/bin/sh
export FLUTTER_HOME=/opt/Flutter
export PATH=\${FLUTTER_HOME}/bin:\${PATH}
"""


def init(manager: str):
    printing.title(_TITLE)

    # Dependecias
    printing.title('Instalación de dependencias')
    PackageManager.pkg_has_installed('Instalación de Bash', manager, 'bash')
    PackageManager.pkg_has_installed('Instalación de curl', manager, 'curl')
    PackageManager.pkg_has_installed('Instalación de file', manager, 'file')
    PackageManager.pkg_has_installed('Instalación de git', manager, 'git')
    PackageManager.pkg_has_installed('Instalación de mkdir', manager, 'mkdir')
    PackageManager.pkg_has_installed('Instalación de rm', manager, 'rm')
    PackageManager.pkg_has_installed('Instalación de unzip', manager, 'unzip')
    PackageManager.pkg_has_installed('Instalación de which', manager, 'which')
    PackageManager.pkg_has_installed('Instalación de zip', manager, 'zip')
    PackageManager.pkg_has_installed('Instalación de cmake', manager, 'cmake')
    PackageManager.pkg_has_installed('Instalación de clang', manager, 'clang')

    printing.title('Instalación de CoreUtils')
    PackageManager.try_install(manager, 'coreutils')

    # Instalación de xz
    printing.message('Instalación de xz & mesa')

    if manager == PackageManager.APT_MANAGER:
        PackageManager.try_install(manager, 'xz-utils')
        PackageManager.try_install(manager, 'libglu1-mesa')

    if not manager == PackageManager.APT_MANAGER:
        PackageManager.try_install(manager, 'xz')

    if manager == PackageManager.DNF_MANAGER:
        PackageManager.try_install(manager, 'mesa-libGLU')

    if manager == PackageManager.PACMAN_MANAGER:
        PackageManager.try_install(manager, 'glu')

    start()


def start():
    printing.welcome(_TITLE)
    printing.title('Crear carpeta temporal')
    TemporalFile.temp_folder_create()

    printing.title('Descargar Flutter')
    wget_util.download(f'https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/{_FLUTTER_VERSION}')

    printing.title('Descomprimir Flutter')
    uncompress.un_tarxz(f'{TemporalFile.FOLDER_TEMP}/{_FLUTTER_VERSION}', TemporalFile.FOLDER_TEMP)

    printing.title('Mover Flutter a /opt/')
    SystemInformation.request_root_permission()
    os.system(f'sudo mv temp/flutter {_FLUTTER_PATH}')

    printing.title('Agregar Flutter al Path de Linux')
    os.system(f'echo """{_EXPORT_PATH}""" | sudo tee -a {_FLUTTER_PATH_LINUX}')

    printing.title('Agregar permiso de ejecución al adb en el path de Linux')
    os.system(f'sudo chmod +x {_FLUTTER_PATH_LINUX}')

    try:
        os.system(f"su -c '{_FLUTTER_PATH_LINUX}' root")

        printing.title('Mostrar información de Flutter')
        os.system(f'{_FLUTTER_PATH}/bin/flutter doctor')

        printing.message('En algunas distribuciones requiere reiniciar el sistema')
    except OSError:
        printing.warning('Deberá ejecutar el siguiente comando para agregar ADB al PATH de Linux')
        printing.message(f'source {_FLUTTER_PATH_LINUX}')

    TemporalFile.folder_delete('temp')

