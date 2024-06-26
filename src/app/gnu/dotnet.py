import os

from src.config import TemporalFile, Printing

_TITLE = 'Instalación de Gradle'

_DOTNET_PATH_LINUX = '/etc/profile.d/dotnet.sh'
_DOTNET_PATH = '/usr/share/dotnet'

_EXPORT_PATH = """#!/bin/sh
export DOTNET_HOME=/usr/share/dotnet
export PATH=\${DOTNET_HOME}:\${PATH}
"""


def init(manager: str):
    Printing.welcome(_TITLE)

    Printing.title('Crear carpeta temporal')
    TemporalFile.temp_folder_create()

    Printing.title('Descargar .NET')
    os.system('wget https://dot.net/v1/dotnet-install.sh')
    os.system('chmod +x ./dotnet-install.sh')

    Printing.title('Instalación de .NET 6 SDK y Runtime')
    os.system('sudo bash ./dotnet-install.sh --runtime dotnet --version 6.0.0 --install-dir /usr/share/dotnet')
    os.system('sudo bash ./dotnet-install.sh --channel 6.0.1xx --install-dir /usr/share/dotnet')

    Printing.title('Agregar .NET al Path de Linux')
    os.system(f'echo """{_EXPORT_PATH}""" | sudo tee -a {_DOTNET_PATH_LINUX}')

    Printing.title('Agregar permiso de ejecución al Gradle en el path de Linux')
    os.system(f'sudo chmod +x {_DOTNET_PATH_LINUX}')

    try:
        Printing.title(f'Se require su contraseña para aplicar el comando $ source {_DOTNET_PATH_LINUX}')
        Printing.warning('En caso de no ingresar de manera exitosa su contraseña, favor de ejecutar manualmente')
        Printing.message(f'source {_DOTNET_PATH_LINUX}')
        os.system(f"su -c 'source {_DOTNET_PATH_LINUX}' root")

        Printing.title('Mostrar información de .NET')
        os.system(f'{_DOTNET_PATH}/dotnet --version')

        Printing.message('En algunas distribuciones requiere reiniciar el sistema')
    except OSError:
        Printing.warning('Deberá ejecutar el siguiente comando para agregar .NET al PATH de Linux')
        Printing.message(f'source {_DOTNET_PATH_LINUX}')
