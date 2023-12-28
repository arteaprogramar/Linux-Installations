import os

from src.config import Printing

_TITLE = 'Instalación de Media Transfer Protocol'


def init(manager: str):
    Printing.welcome(_TITLE)
    Printing.message('')

    Printing.title('Actualizar Sistema', True)
    os.system('sudo pacman -Syu --noconfirm')

    Printing.title('Instalacion de paquetes necesarios')
    os.system(f'sudo pacman -S mtpfs gvfs-mtp --noconfirm')

    Printing.title('Se requiere reiniciar el sistema')