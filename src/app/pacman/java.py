import os
import subprocess

from src.config import Printing

_TITLE = 'Instalación de Java (JRE - JDK)'


def init(pkg: str):
    Printing.welcome(_TITLE)
    Printing.message('')

    Printing.title('Buscar versiones disponibles de Java open-(jre/jdk)', False)
    pacman_search = subprocess.check_output("pacman -Ss jre | grep -E 'jre([0-9]{0,2})-openjdk '", shell=True, text=True)
    pacman_search = pacman_search.split("\n")
    versions = filter(lambda p: p != '', pacman_search)

    Printing.title('Lista de versiones disponibles', False)
    selected = -1
    continue_menu = True

    for index, version in enumerate(versions):
        print([version.count('/')])
        version = version[version.count('/'):]
        Printing.message(f"Para instalar Java \033[1m{version}\033[0m ingrese \033[1m{index}\033[0m")