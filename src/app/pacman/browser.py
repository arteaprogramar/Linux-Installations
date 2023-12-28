import os

from src.config import Printing

_TITLE = 'Instalación de Google Chrome & Microsoft Edge'


def init(manager: str):
    Printing.welcome(_TITLE)
    Printing.message('')

    Printing.title('Actualizar Sistema', True)
    os.system('sudo pacman -Syu --noconfirm')

    Printing.title('Instalacion de Chrome')
    os.system(f'yay -S google-chrome --noconfirm')

    Printing.title('Instalacion de Microsoft Edge')
    os.system(f'yay -S microsoft-edge-stable-bin --noconfirm')

