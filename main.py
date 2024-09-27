#!/bin/python

import json
import os

from src.util import Printing, Temporal, PackageManager
from src import PackageInstall, Menu


def parser_int(value: str):
    try:
        return int(value)
    except ValueError:
        return -1


def start():
    Temporal.temp_folder_create()
    pkg_manager = PackageManager.get_package_manager()

    Printing.title("Arte a Programar : v3.0")
    Printing.subtitle(f'Gestor de Paquetes : {pkg_manager}', False)
    Printing.subtitle(f'Arquitectura : {os.uname().machine}')

    packages = json.load(open('pkgs.json'))
    filtered = [item for item in packages if pkg_manager in item["manager"] or "gnu" in item["manager"]]
    option = Menu.show('Lista de paquetes disponibles para instalar', filtered)

    PackageInstall.init(option, pkg_manager)

if __name__ == '__main__':
    start()

