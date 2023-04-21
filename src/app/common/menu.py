import main
from src.config import Printing


def show_menu(title : str, versions : [], breaking: int = -1):
    Printing.title(title)

    for index, version in enumerate(versions):
        Printing.message(f"Para instalar Gradle \033[1m{version}\033[0m ingrese \033[1m{index}\033[0m")

        if breaking != -1:
            break


def select_item(versions : []):
    selected = -1
    continue_menu = True

    while continue_menu:
        selected = main.parser_int(input('¿Que version de Gradle deseas instalar? : '))

        if selected > -1 and selected < len(versions):
            continue_menu = False

    return selected