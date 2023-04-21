import os
import subprocess

import main
from src.config import Printing

_TITLE = 'Instalación de Java (JRE - JDK)'


def init(manager: str):
    Printing.welcome(_TITLE)
    Printing.message('')

    Printing.title('Buscar versiones disponibles de Java open-(jre/jdk)', False)
    pacman_search = subprocess.check_output("pacman -Ss jre | grep -E 'jre([0-9]{0,2})-openjdk '", shell=True, text=True)
    pacman_search = pacman_search.split("\n")
    versions = list(filter(lambda pkg: pkg != '', pacman_search))
    versions = list(map(lambda pkg: pkg[(pkg.find('/') + 1): pkg.find(' ')], versions))

    Printing.title('Lista de versiones disponibles', False)
    selected = -1
    continue_menu = True

    for index, version in enumerate(versions):
        Printing.message(f"Para instalar Java \033[1m{version}\033[0m ingrese \033[1m{index}\033[0m")

    while continue_menu:
        selected = main.parser_int(input('¿Que version de Java deseas instalar? : '))

        if selected < len(pacman_search):
            continue_menu = False

    Printing.title('Instalación de Java')
    text_version = versions[selected]

    version = main.parser_int(''.join(filter(str.isdigit, text_version)))

    if version == -1:
        version = ''

    jre = f'jre{version}-openjdk'
    jdk = f'jdk{version}'

    packages = f'{jre}-headless jre{version}-openjdk {jdk}-openjdk openjdk{version}-doc openjdk{version}-src'
    os.system(f'sudo pacman -S {packages} --noconfirm')

    Printing.title('Se ha instalado java')
    os.system('java --version')