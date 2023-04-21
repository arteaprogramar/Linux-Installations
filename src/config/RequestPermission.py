# 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
import os
import sys

from src.config import Printing


def check_permission():
    return os.getuid() != 0


def request_permission():
    if not check_permission():
        Printing.title('Se requieren permisos administrativos para ejecutar el script de instalación')
        args = ['sudo', sys.executable] + sys.argv + [os.environ]
        os.execlpe('sudo', *args)
