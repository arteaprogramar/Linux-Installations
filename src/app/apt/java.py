import os
import platform
import subprocess

import main
from src.config import Printing

_TITLE = 'Instalación de OpenJDK'


def init(manager: str):
    Printing.welcome(_TITLE)
    Printing.message('')

    Printing.title('Actualizar Sistema', True)

    Printing.title('Obtener versiones disponibles de Java')
    selected = -1
    continue_menu = True

    try:
        result = subprocess.run(
            "apt-cache search jdk | grep openjdk | awk -F '-' '{ if ($2 ~ /^[0-9]+$/) print $2}' | awk '!seen[$0]++'",
            shell=True,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )

        versions = result.stdout.decode('utf-8').strip().split('\n')

        for index, version in enumerate(versions):
            Printing.message(f"Para instalar Java \033[1m{version}\033[0m ingrese \033[1m{index}\033[0m")

        while continue_menu:
            selected = main.parser_int(input('¿Que version de Java deseas instalar? : '))

            if selected <= len(versions):
                continue_menu = False

        Printing.title('Instalacion de Java')
        java_version = f'{versions[selected]}'
        os.system(f'sudo apt -y install openjdk-{java_version}-jdk openjdk-{java_version}-jre')

    except subprocess.CalledProcessError as e:
        print(f"Error: {e.stderr.decode('utf-8')}")
