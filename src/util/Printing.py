from src.util.Color import Color


def title(text : str, require_new_line : bool = True):
    print(Color.BOLD + text + Color.END)

    if require_new_line:
        print("")


def warning(text : str, require_new_line : bool = True):
    print(Color.RED + text + Color.END)

    if require_new_line:
        print("")


def subtitle(text: str, require_new_line : bool = True):
    print(Color.ITALIC + text + Color.END)

    if require_new_line:
        print("")
