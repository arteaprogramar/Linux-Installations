import os

from src.app.common import wget_util, uncompress
from src.config import PackageManager, TemporalFile, SystemInformation, Printing

_TITLE = 'Instalación de Flutter'

_FLUTTER_VERSION = 'flutter_linux_3.7.10-stable.tar.xz'
_FLUTTER_PATH_LINUX = '/etc/profile.d/flutter.sh'
_FLUTTER_PATH = '/opt/Flutter'

_EXPORT_PATH = """#!/bin/sh
export FLUTTER_HOME=/opt/Flutter
export PATH=\${FLUTTER_HOME}/bin:\${PATH}
"""


def init(manager: str):
    Printing.title(_TITLE)

    # Dependecias
    Printing.title('Instalación de dependencias')
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

    Printing.title('Instalación de CoreUtils')
    PackageManager.try_install(manager, 'coreutils')

    # Instalación de xz
    Printing.message('Instalación de xz & mesa')

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
    Printing.welcome(_TITLE)
    Printing.title('Crear carpeta temporal')
    TemporalFile.temp_folder_create()

    Printing.title('Descargar Flutter')
    wget_util.download(f'https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/{_FLUTTER_VERSION}')

    Printing.title('Descomprimir Flutter')
    uncompress.un_tarxz(f'{TemporalFile.FOLDER_TEMP}/{_FLUTTER_VERSION}', TemporalFile.FOLDER_TEMP)

    Printing.title('Mover Flutter a /opt/')
    # SystemInformation.request_root_permission()
    os.system(f'sudo mv temp/flutter {_FLUTTER_PATH}')

    Printing.title('Agregar Flutter al Path de Linux')
    os.system(f'echo """{_EXPORT_PATH}""" | sudo tee -a {_FLUTTER_PATH_LINUX}')

    Printing.title('Agregar permiso de ejecución al adb en el path de Linux')
    os.system(f'sudo chmod +x {_FLUTTER_PATH_LINUX}')

    try:
        Printing.title(f'Se require su contraseña para aplicar el comando $ source {_FLUTTER_PATH_LINUX}')
        Printing.warning('En caso de no ingresar de manera exitosa su contraseña, favor de ejecutar manualmente')
        Printing.message(f'source {_FLUTTER_PATH_LINUX}')
        os.system(f"su -c 'source {_FLUTTER_PATH_LINUX}' root")

        Printing.title('Mostrar información de Flutter')
        os.system(f'{_FLUTTER_PATH}/bin/flutter doctor')

        Printing.message('En algunas distribuciones requiere reiniciar el sistema')
    except OSError:
        Printing.warning('Deberá ejecutar el siguiente comando para agregar ADB al PATH de Linux')
        Printing.message(f'source {_FLUTTER_PATH_LINUX}')

    TemporalFile.folder_delete('temp')
