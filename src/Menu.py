from main import parser_int
from src.util import Printing


def show(title : str, list):
    """
    Require un array que tenga la llave 'name' para funcionar
    :param title:
    :param list:
    :return:
    """
    Printing.title(title, False)
    selected = -1

    for index, item in enumerate(list):
        value = item['name'] if 'name' in item else list[index]
        print(f"[\033[1m{index}\033[0m] {value}")

    continue_menu = True

    while continue_menu:
        selected = parser_int(input("Ingrese una opción : "))

        if selected < len(list):
            continue_menu = False

    print("\n")
    return list[selected]
