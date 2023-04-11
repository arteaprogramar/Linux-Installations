#!/bin/python
import json

import run
from src.config import SystemInformation, PackageManager


def parser_int(value: str):
    try:
        return int(value)
    except ValueError:
        return -1


def start():
    printing.welcome()

    pkgs = []
    manager = PackageManager.get_pm()

    printing.message('-----------------------------------------------------------')
    printing.message(f'Sistema Operativo : {SystemInformation.getInformation.get_name_system()}')
    printing.message(f'Versión del Sistema : {SystemInformation.getInformation.get_id_system()}')
    printing.message(f'Versión del Kernel : {SystemInformation.getInformation.get_kernel_version()}')
    printing.message(f'Gestor de Paquetes : {manager}')
    printing.message('-----------------------------------------------------------')
    printing.message('\n')

    apps = open('src/apps.json')

    for pkg in json.load(apps):
        if pkg['manager'] == 'gnu' or pkg['manager'] == manager:
            pkgs.append(pkg)

    show_menu(manager, pkgs)


def show_menu(manager: str, lists):
    printing.title('Lista de paquetes disponibles para instalar', False)

    for index, pkg in enumerate(lists):
        print(f"[{index}] {pkg['name']}")

    continue_menu = True
    selected = -1

    while continue_menu:
        selected = parser_int(input('Ingrese un número: '))

        if selected >= 0 & selected <= len(lists):
            continue_menu = False

    running = getattr(run, f"{lists[selected]['manager']}_{lists[selected]['pkg']}")
    running(manager)


if __name__ == '__main__':
    start()
