import os
import platform

from src.config import Printing

_TITLE = 'Instalación de Node 20+'


def init(manager: str):
    Printing.welcome(_TITLE)
    Printing.message('')

    Printing.title('Actualizar Sistema', True)

    Printing.title('Instalación de NodeJS')
    os.system(f'sudo curl -sL https://deb.nodesource.com/setup_22.x -o /tmp/nodesource_setup.sh')
    os.system(f'sudo bash /tmp/nodesource_setup.sh')
    os.system(f'sudo apt install -y nodejs')
    os.system(f'node --version')


