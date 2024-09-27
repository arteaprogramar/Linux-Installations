#!/bin/python

import json
import os

from src.util import Printing, Download, PackageManager
from src import PackageInstall, Menu


def parser_int(value: str):
    try:
        return int(value)
    except ValueError:
        return -1


def start():
    pkg_manager = PackageManager.get_package_manager()

    Printing.title("Arte a Programar : v3.0")
    Printing.subtitle(f'Gestor de Paquetes : {pkg_manager}', False)
    Printing.subtitle(f'Arquitectura : {os.uname().machine}')

    packages = json.load(open('pkgs.json'))
    option = Menu.show('Lista de paquetes disponibles para instalar', packages)

    PackageInstall.init(option, pkg_manager)


if __name__ == '__main__':
    start()

