class Color:
    PURPLE = '\033[95m'
    CYAN = '\033[96m'
    DARKCYAN = '\033[36m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'


def welcome(pkgToInstalled=None):
    message('')
    message('-----------------------------------------------------------')
    title('Bienvenido al Script de Instalaciones de Arte a Programar', False)
    message('Version : 1.0')

    if pkgToInstalled is not None:
        message(pkgToInstalled)

    message('-----------------------------------------------------------')


def title(txt: str, jumpLine=True):
    print('')
    print(Color.BOLD + txt + Color.END)

    if jumpLine:
        print('')


def message(txt: str, jumpLine=False):
    print(txt)

    if jumpLine:
        print('')


def warning(txt: str, jumpLine=False):
    print(Color.RED + txt + Color.END)

    if jumpLine:
        print('')