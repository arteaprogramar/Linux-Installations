#!/bin/python

import json

import run
from src.config import SystemInformation, PackageManager, Printing


def parser_int(value: str):
    try:
        return int(value)
    except ValueError:
        return -1


def start():
    Printing.welcome()

    pkgs = []
    manager = PackageManager.get_pm()

    Printing.message('-----------------------------------------------------------')
    Printing.message(f'Sistema Operativo : {SystemInformation.getInformation.get_name_system()}')
    Printing.message(f'Versión del Sistema : {SystemInformation.getInformation.get_id_system()}')
    Printing.message(f'Versión del Kernel : {SystemInformation.getInformation.get_kernel_version()}')
    Printing.message(f'Gestor de Paquetes : {manager}')
    Printing.message('-----------------------------------------------------------')
    Printing.message('\n')

    apps = open('src/apps.json')

    for pkg in json.load(apps):
        if pkg['manager'] == 'gnu' or pkg['manager'] == manager:
            pkgs.append(pkg)

    show_menu(manager, pkgs)


def show_menu(manager: str, lists):
    Printing.title('Lista de paquetes disponibles para instalar', False)

    for index, pkg in enumerate(lists):
        print(f"[{index}] {pkg['name']}")

    continue_menu = True
    selected = -1

    while continue_menu:
        selected = parser_int(input('Ingrese un número: '))

        if selected < len(lists):
            continue_menu = False

    running = getattr(run, f"{lists[selected]['manager']}_{lists[selected]['pkg']}")
    running(manager)


if __name__ == '__main__':
    start()
