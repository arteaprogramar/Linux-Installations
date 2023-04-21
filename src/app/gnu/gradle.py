import json
import os

import main
from src.app.common import wget_util, uncompress
from src.config import PackageManager, TemporalFile, SystemInformation, Printing

_TITLE = 'Instalación de Gradle'

_GRADLE_VERSION = 'gradle-{}-all.zip'
_GRADLE_PATH_LINUX = '/etc/profile.d/gradle.sh'
_GRADLE_PATH = '/opt/Gradle'

_EXPORT_PATH = """#!/bin/sh
export GRADLE_HOME=/opt/Gradle
export PATH=\${GRADLE_HOME}/bin:\${PATH}
"""


def init(manager: str):
    Printing.title(_TITLE)

    # Requerimientos
    Printing.title('Comprobar version de Java')
    installed = PackageManager.pkg_exists('java')

    if not installed:
        Printing.warning('Se requiere Java')
        Printing.message('Antes de ejecutar este script instale Java en su ordenador', True)
        # return

    # Dependecias
    Printing.title('Instalación de dependencias')
    # PackageManager.pkg_has_installed('Instalación de Bash', manager, 'wget')

    start()


def start():
    Printing.welcome(_TITLE)

    Printing.title('Crear carpeta temporal')
    TemporalFile.temp_folder_create()

    Printing.title('Descargando lista de Gradle Disponibles')
    wget_util.download('https://raw.githubusercontent.com/gradle/gradle/master/released-versions.json')

    Printing.title('Obteniendo lista de versiones de Gradle', False)
    gradle_json = open('temp/released-versions.json')
    data = json.load(gradle_json)['finalReleases']

    selected = -1
    continue_menu = True

    for index, version in enumerate(data):
        Printing.message(f"Para instalar Gradle \033[1m{version['version']}\033[0m ingrese \033[1m{index}\033[0m")

        if index == 20:
            break

    while continue_menu:
        selected = main.parser_int(input('¿Que version de Gradle deseas instalar? : '))

        if selected <= 20:
            continue_menu = False

    gradle = data[selected]['version']

    Printing.title('Descargar Gradle')
    wget_util.download(f'https://services.gradle.org/distributions/{_GRADLE_VERSION.format(gradle)}')

    Printing.title('Descomprimir Gradle')
    uncompress.unzip(f'{TemporalFile.FOLDER_TEMP}/{_GRADLE_VERSION.format(gradle)}', TemporalFile.FOLDER_TEMP)

    Printing.title('Mover Gradle a /opt/')
    # SystemInformation.request_root_permission()
    os.system(f"sudo mv temp/gradle-{gradle} {_GRADLE_PATH}")

    Printing.title('Agregar Gradle al Path de Linux')
    os.system(f'echo """{_EXPORT_PATH}""" | sudo tee -a {_GRADLE_PATH_LINUX}')

    Printing.title('Agregar permiso de ejecución al Gradle en el path de Linux')
    os.system(f'sudo chmod +x {_GRADLE_PATH_LINUX}')

    try:
        Printing.title(f'Se require su contraseña para aplicar el comando $ source {_GRADLE_PATH_LINUX}')
        Printing.warning('En caso de no ingresar de manera exitosa su contraseña, favor de ejecutar manualmente')
        Printing.message(f'source {_GRADLE_PATH_LINUX}')
        os.system(f"su -c 'source {_GRADLE_PATH_LINUX}' root")

        Printing.title('Mostrar información de Gradle')
        os.system(f'{_GRADLE_PATH}/bin/gradle --version')

        Printing.message('En algunas distribuciones requiere reiniciar el sistema')
    except OSError:
        Printing.warning('Deberá ejecutar el siguiente comando para agregar Gradle al PATH de Linux')
        Printing.message(f'source {_GRADLE_PATH_LINUX}')

    TemporalFile.folder_delete('temp')
